################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }
}

################################################################################
## lookups
################################################################################
data "aws_caller_identity" "this" {}

data "aws_partition" "this" {}

################################################################################
## kms
################################################################################
## kms
data "aws_iam_policy_document" "ec2_ebs_kms" {
  version = "2012-10-17"

  ## allow ec2 access to the key
  statement {
    effect = "Allow"

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]

    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.this.partition}:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
  }

  ## allow administration of the key
  dynamic "statement" {
    for_each = sort(toset(var.kms_admin_iam_role_identifier_arns))

    content {
      effect    = "Allow"
      actions   = ["kms:*"]
      resources = ["*"]

      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
    }
  }
}

module "ec2_ebs_kms" {
  source = "git::https://github.com/cloudposse/terraform-aws-kms-key?ref=0.12.1"

  name                    = var.name
  description             = "KMS key for EC2 EBS encryption."
  label_key_case          = "lower"
  multi_region            = false
  deletion_window_in_days = 30
  enable_key_rotation     = true
  alias                   = "alias/${var.namespace}/${var.environment}/${var.name}"
  policy                  = data.aws_iam_policy_document.ec2_ebs_kms.json

  tags = var.tags
}

################################################################################
## ec2
################################################################################
module "ec2_key_pair" {
  source = "git::https://github.com/cloudposse/terraform-aws-key-pair?ref=0.18.3"

  name                  = var.name
  namespace             = var.namespace
  stage                 = var.environment
  ssh_public_key_path   = "${path.root}/secrets"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"

  tags = var.tags
}

module "ec2" {
  source = "git::https://github.com/cloudposse/terraform-aws-ec2-instance?ref=0.44.0"

  name             = var.name
  namespace        = var.namespace
  stage            = var.environment
  vpc_id           = var.vpc_id
  subnet           = var.subnet
  instance_type    = var.ami.instance_type
  ami              = var.ami.id
  ami_owner        = var.ami.owner
  user_data        = var.user_data
  instance_profile = var.instance_profile
  ssh_key_pair     = module.ec2_key_pair.key_name

  ssm_patch_manager_enabled    = false
  associate_public_ip_address  = false
  volume_tags_enabled          = true
  root_block_device_encrypted  = true
  root_volume_size             = var.root_volume_size
  root_volume_type             = var.root_volume_type
  root_block_device_kms_key_id = module.ec2_ebs_kms.key_arn
  ebs_optimized                = var.ebs_optimized
  security_group_rules         = var.security_group_rules

  tags = var.tags

  depends_on = [
    module.cloudwatch_log_group,
    #module.iam_instance_profile,
    module.iam
  ]
}

# Connect to AWS Directory Service
# data "aws_directory_service_directory" "ad" {
#   directory_id = var.directory_id
# }

# AD Join 
# resource "aws_ssm_document" "api_ad_join_domain" {
#   name          = "ad-join-domain"
#   document_type = "Command"
#   content = jsonencode(
#     {
#       "schemaVersion" = "2.2"
#       "description"   = "aws:domainJoin"
#       "mainSteps" = [
#         {
#           "action" = "aws:domainJoin",
#           "name"   = "domainJoin",
#           "inputs" = {
#             "directoryId" : data.aws_directory_service_directory.ad.id,
#             "directoryName" : data.aws_directory_service_directory.ad.name,
#             "dnsIpAddresses" : sort(data.aws_directory_service_directory.ad.dns_ip_addresses)
#           }
#         }
#       ]
#     }
#   )
# }

# # Associate Policy to Instance
# resource "aws_ssm_association" "ad_join_domain_association" {
#   depends_on = [module.ec2]
#   name       = aws_ssm_document.api_ad_join_domain.name
#   targets {
#     key    = "InstanceIds"
#     values = [module.ec2.id]
#   }
# }

##cloudwatch-log-group:
module "cloudwatch_log_group" {
  source               = "../cloudwatch-log-group"
  for_each             = var.cloudwatch_log_groups
  cloudwatch_log_group = each.value.cloudwatch_log_group

  tags = var.tags
}

###cloudwatch-log-stream
module "cloudwatch_log_stream" {
  source                = "../cloudwatch-log-stream"
  for_each              = var.cloudwatch_log_streams
  cloudwatch_log_stream = each.value.cloudwatch_log_stream
  depends_on = [
    module.cloudwatch_log_group
  ]
}

module "iam" {
  source                   = "../iam"
  for_each                 = var.iam_service_roles
  iam_role                 = each.value.iam_role
  aws_managed_policy_names = each.value.aws_managed_policy_names

  tags = var.tags
  depends_on = [
    module.common_customer_managed_policies
  ]
}

###iam-instance-profile
# module "iam_instance_profile" {
#   source               = "../iam-instance-profile"
#   for_each             = var.iam_instance_profiles
#   iam_instance_profile = each.value.iam_instance_profile

#   tags = var.tags
#   depends_on = [
#     module.iam
#   ]
# }
###customer-managed-policies:
module "common_customer_managed_policies" {
  source   = "../policy"
  for_each = var.common_customer_managed_policies

  create_aws_iam_policy = each.value.create_aws_iam_policy
  name                  = each.value.name
  description           = each.value.description
  policy_statement      = each.value.policy_statement
}
