################################################################################
## defaults
################################################################################
variable "name" {
  description = "Name to assign the resource"
  type        = string
}

variable "namespace" {
  description = "Namespace the resource belongs to"
  type        = string
}

variable "environment" {
  description = "Name of the environment the resource belongs to"
  type        = string
}

variable "vpc_id" {
  description = "Id of the VPC where the resources will live"
  type        = string
}

variable "tags" {
  description = "Tags to assign the resources"
  type        = map(string)
  default     = {}
}

################################################################################
## ec2
################################################################################

variable "ebs_optimized" {
  description = "Optimize the EBS volume"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root volume for the EC2 instance"
  type        = string
  default     = "20"
}

variable "root_volume_type" {
  description = "Type of the root volume for the EC2 instance"
  type        = string
  default     = "gp2"
}

variable "user_data" {
  type        = string
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; use `user_data_base64` instead"
  default     = null
}

variable "security_group_rules" {
  description = "List of security group ingress and egress rules."
  type = list(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "subnet" {
  description = "Subnet id the resource belongs to"
  type        = string
}

variable "instance_profile" {
  type        = string
  description = "A pre-defined profile to attach to the instance (default is to build our own)"
  default     = "AWSAccelerator-SessionManagerEC2Role-eu-west-2"
}

################################################################################
## kms
################################################################################
variable "kms_admin_iam_role_identifier_arns" {
  description = "IAM Role ARN to add to the KMS key for management."
  type        = list(string)
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type = object({
    id            = string
    owner         = optional(string)
    instance_type = string
  })
  default = {
    id            = "" // Windows AMI
    owner         = ""
    instance_type = "" // required for the ami Instance Type
  }
}

###cloudwatch-log-group:
variable "cloudwatch_log_groups" {
  type = map(object({
    cloudwatch_log_group = list(object({
      name              = string
      retention_in_days = optional(number)
      kms_key_id        = optional(string)
    }))
  }))
  description = "Map object to define the cloudwatch log group names"
  default     = {}
}

###cloudwatch-log-stream:
variable "cloudwatch_log_streams" {
  type = map(object({
    cloudwatch_log_stream = list(object({
      name           = string
      log_group_name = string
    }))
  }))
  description = "Map object to define the cloudwatch log stream names"
  default     = {}
}

###iam-instance-profile
# variable "iam_instance_profiles" {
#   type = map(object({
#     iam_instance_profile = list(object({
#       name          = string
#       iam_role_name = string
#     }))
#   }))
#   default     = {}
#   description = "map of object that are described to create iam instance profile"
# }

###iam-service-role:
variable "iam_service_roles" {
  type = map(object({
    iam_role = list(object({
      role_name             = string
      assume_role_names     = list(string)
      aws_assume_role_names = optional(list(string), [])
      inline_policy         = any
    }))
    aws_managed_policy_names = optional(list(string), [])
  }))
  description = "Service Role used for the codebuild project"
  default     = {}
}

###customer-managed-policy
variable "common_customer_managed_policies" {
  type = map(object({
    create_aws_iam_policy = optional(bool, true)
    name                  = string
    description           = optional(string)
    policy_statement = list(object({
      Sid      = optional(string, "")
      Action   = list(string)
      Resource = list(string)
      Effect   = string
    }))
  }))
  default     = {}
  description = "customer managed policies configuration"
}

# variable "directory_id" {
#   description = "The ID of the directory"
#   type        = string
#   default     = ""
# }