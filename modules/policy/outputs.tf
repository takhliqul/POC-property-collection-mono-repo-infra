output "id" {
  description = "The ARN assigned by AWS to this policy."
  value       = aws_iam_policy.this[*].id
}

output "arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = aws_iam_policy.this[*].arn
}
