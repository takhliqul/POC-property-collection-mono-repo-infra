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

resource "aws_iam_policy" "this" {
  count = var.create_aws_iam_policy == true ? 1 : 0

  name        = var.name
  description = var.description

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = var.policy_statement
  })
}
