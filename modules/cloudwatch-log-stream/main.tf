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

resource "aws_cloudwatch_log_stream" "this" {
  for_each       = { for x in var.cloudwatch_log_stream : x.name => x }
  name           = each.value.name
  log_group_name = each.value.log_group_name
}
