output "arn" {
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.arn }
  description = "The Amazon Resource Name (ARN) specifying the log group. Any :* suffix added by the API, denoting all CloudWatch Log Streams under the CloudWatch Log Group, is removed for greater compatibility with other AWS services that do not accept the suffix."
}

output "tags_all" {
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.tags_all }
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
}
