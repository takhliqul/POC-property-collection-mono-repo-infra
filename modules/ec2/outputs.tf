################################################################################
## private ec2
################################################################################
output "name" {
  description = "EC2 instance name"
  value       = module.ec2.name
}

output "private_ip" {
  description = "EC2 instance private IP addresses"
  value       = module.ec2.private_ip
}

output "private_dns" {
  description = "EC2 instance private DNS"
  value       = module.ec2.private_dns
}

output "ec2_arn" {
  description = "EC2 ARN"
  value       = module.ec2.arn
}

output "security_group_arn" {
  description = "EC2 Security Group arn"
  value       = module.ec2.security_group_arn
}

output "security_group_ids" {
  description = "EC2 Security Group IDs"
  value       = module.ec2.security_group_ids
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = module.ec2.id
}