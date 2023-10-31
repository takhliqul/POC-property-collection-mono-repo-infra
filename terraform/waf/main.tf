################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

 backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags.git?ref=1.2.1"

  environment = var.environment
  project     = var.project_name

  extra_tags = {
    MonoRepo     = "True"
    MonoRepoPath = "terraform/waf"
  }
}

################################################################################
## waf
################################################################################
module "waf" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-waf.git?ref=0.0.2"

  ## web acl
  create_web_acl         = true
  web_acl_name           = "${var.namespace}-${var.environment}-waf-web-acl"
  web_acl_description    = "Terraform managed Web ACL Configuration"
  web_acl_scope          = "REGIONAL"
  web_acl_default_action = "block"
  web_acl_visibility_config = {
    metric_name = "${var.namespace}-${var.environment}-waf-web-acl"
  }
  web_acl_rules = var.web_acl_rules

  ## vpc-subnets
  # vpc-subnets = [
  #   {
  #     name               = "vpc-subnets"
  #     description        = "IP Set for VPC Subnet CIDRs"
  #     scope              = "REGIONAL"
  #     ip_address_version = "IPV4"
  #     addresses          = concat(local.private_subnet_cidr, local.public_subnet_cidr)
  #   }
  # ]

  tags = module.tags.tags
}
