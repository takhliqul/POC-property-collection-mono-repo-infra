################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }
}

resource "aws_iam_instance_profile" "this" {
  for_each = { for x in var.iam_instance_profile : x.name => x }
  name     = each.value.name
  role     = each.value.iam_role_name
  tags     = var.tags
}