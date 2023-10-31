data "aws_iam_policy" "aws_managed_policies" {
  for_each = toset(var.aws_managed_policy_names)
  name     = each.value
}
