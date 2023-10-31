output "arn" {
  value       = { for k, v in aws_cloudwatch_log_stream.this : k => v.arn }
  description = "The Amazon Resource Name (ARN) specifying the log stream"
}
