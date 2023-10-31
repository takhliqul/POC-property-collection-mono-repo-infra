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
################################################################################
## role
################################################################################
resource "aws_iam_role" "this" {
  for_each = { for x in var.iam_role : x.role_name => x }

  name = each.value.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = each.value.assume_role_names
          AWS     = each.value.aws_assume_role_names
        }
      },
    ]
  })

  dynamic "inline_policy" {
    for_each = each.value.inline_policy
    content {
      name = lookup(inline_policy.value, "name")
      policy = jsonencode({
        Version   = "2012-10-17"
        Statement = lookup(inline_policy.value, "Statement")
      })
    }
  }
  managed_policy_arns = local.managed_policy_arns
  tags                = var.tags
}
