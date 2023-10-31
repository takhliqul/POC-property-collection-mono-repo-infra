output "arn" {
  value       = { for k, v in aws_iam_role.this : k => v.arn }
  description = "The ARNs of the IAM roles created"
}

output "id" {
  value       = { for k, v in aws_iam_role.this : k => v.id }
  description = "The IDs of the IAM roles created"
}
