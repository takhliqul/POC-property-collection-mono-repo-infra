output "arn" {
  value       = { for k, v in aws_iam_instance_profile.this : k => v.arn }
  description = "ARN assigned by AWS to the instance profile"
}

output "id" {
  value       = { for k, v in aws_iam_instance_profile.this : k => v.id }
  description = "Instance profile's ID"
}

output "create_date" {
  value       = { for k, v in aws_iam_instance_profile.this : k => v.create_date }
  description = "Creation timestamp of the instance profile"
}

output "unique_id" {
  value       = { for k, v in aws_iam_instance_profile.this : k => v.unique_id }
  description = "Unique ID assigned by AWS"
}

output "tags_all" {
  value       = { for k, v in aws_iam_instance_profile.this : k => v.tags_all }
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
}