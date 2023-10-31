################################################################
## defaults
################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags?ref=1.2.1"

  environment = var.environment
  project     = var.project_name

  extra_tags = {
    MonoRepo     = "True"
    MonoRepoPath = "terraform/webserver"
  }
}

################################################################################
## ec2 instance
module "ec2_webservers" {
  source   = "../../modules/ec2"

  for_each = { for x in local.webservers_ec2.dev : x.name => x }

  name                               = each.value.name
  namespace                          = var.namespace
  environment                        = var.environment
  vpc_id                             = data.aws_vpc.vpc.id
  subnet                             = each.value.subnet_id
  ami                                = each.value.ami
  ebs_optimized                      = each.value.ebs_optimized
  kms_admin_iam_role_identifier_arns = var.kms_admin_iam_role_identifier_arns
  root_volume_size                   = each.value.volume_size
  root_volume_type                   = "gp3"
  instance_profile                   = var.instance_profile
  cloudwatch_log_groups              = var.cloudwatch_log_groups
  cloudwatch_log_streams             = var.cloudwatch_log_streams
  common_customer_managed_policies   = var.common_customer_managed_policies
  iam_service_roles                  = var.iam_service_roles
  # directory_id                       = var.directory_id
  #iam_instance_profiles              = var.iam_instance_profiles
  security_group_rules               = local.ec2_security_group_rules

  tags = module.tags.tags

}
## ALB

module "alb" {
  source   = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=1.10.0"
  for_each = local.alb

  load_balancer_name                = var.load_balancer_name
  vpc_id                            = data.aws_vpc.vpc.id
  security_group_ids                = each.value.security_group_ids
  subnet_ids                        = data.aws_subnets.public.ids
  internal                          = var.internal
  http_enabled                      = var.http_enabled
  http_redirect                     = var.http_redirect
  access_logs_enabled               = var.access_logs_enabled
  cross_zone_load_balancing_enabled = var.cross_zone_load_balancing_enabled
  http2_enabled                     = var.http2_enabled
  idle_timeout                      = var.idle_timeout
  ip_address_type                   = var.ip_address_type
  deletion_protection_enabled       = var.deletion_protection_enabled
  deregistration_delay              = var.deregistration_delay
  health_check_path                 = var.health_check_path
  health_check_timeout              = var.health_check_timeout
  health_check_healthy_threshold    = var.health_check_healthy_threshold
  health_check_unhealthy_threshold  = var.health_check_unhealthy_threshold
  health_check_interval             = var.health_check_interval
  health_check_matcher              = var.health_check_matcher
  target_group_name                 = var.target_group_name
  target_group_port                 = var.target_group_port
  target_group_target_type          = var.target_group_target_type
  stickiness                        = var.stickiness
}
module "security_groups" {
  source   = "../../modules/security-groups"
  for_each = var.sgs

  name                  = each.value.name
  description           = each.value.description
  vpc_id                = data.aws_vpc.vpc.id
  ingress_rules         = each.value.ingress_rules
  egress_rules          = each.value.egress_rules
  create_security_group = each.value.create_security_group

  tags = {
    Name = "${var.environment}"
  }
}

resource "aws_lb_target_group_attachment" "ec2_instance_attachment" {
  for_each         = local.ec2_instance_attachment
  target_group_arn = each.value.target_group_arn
  target_id        = each.value.target_id
  port             = var.instance_target_group_port
  depends_on = [
    module.alb
  ]
}
