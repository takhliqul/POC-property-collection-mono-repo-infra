locals {
  managed_policy_arns = concat(
    [for policy in data.aws_iam_policy.aws_managed_policies : policy.arn]
  )
}
