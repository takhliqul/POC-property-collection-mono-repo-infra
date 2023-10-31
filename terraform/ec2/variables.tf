################################################################################
## defaults
################################################################################
variable "project_name" {
  type        = string
  description = "Name of the project."
  default     = "Property-Collection"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Name of the environment resources belong to."
  default     = "dev"

}

variable "namespace" {
  type        = string
  description = "Namespace for the resources."
  default     = "pc"
}

################################################################################
## ec2
################################################################################
variable "kms_admin_iam_role_identifier_arns" {
  type        = list(string)
  description = "IAM Role ARN to add to the KMS key for management"
  default     = []
}

variable "instance_profile" {
  description = "IAM Instance Profile to instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

# variable "directory_id" {
#   description = "The ID of the directory"
#   type        = string
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
variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}
variable "internal" {
  type        = bool
  description = "A boolean flag to determine whether the ALB should be internal"
}

variable "http_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable HTTP listener"
}

variable "http_redirect" {
  type        = bool
  description = "A boolean flag to enable/disable HTTP redirect to HTTPS"
}

variable "access_logs_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable access_logs"
}

variable "cross_zone_load_balancing_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable cross zone load balancing"
}

variable "http2_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable HTTP/2"
}

variable "idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle"
}

variable "ip_address_type" {
  type        = string
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`."
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable deletion protection for ALB"
}

variable "deregistration_delay" {
  type        = number
  description = "The amount of time to wait in seconds before changing the state of a deregistering target to unused"
}

variable "health_check_path" {
  type        = string
  description = "The destination for the health check request"
}

variable "health_check_timeout" {
  type        = number
  description = "The amount of time to wait in seconds before failing a health check request"
}

variable "health_check_healthy_threshold" {
  type        = number
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_interval" {
  type        = number
  description = "The duration in seconds in between health checks"
}

variable "health_check_matcher" {
  type        = string
  description = "The HTTP response codes to indicate a healthy check"
}

variable "target_group_port" {
  type        = number
  description = "The port for the default target group"
}

variable "target_group_target_type" {
  type        = string
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}

variable "stickiness" {
  type = object({
    cookie_duration = number
    enabled         = bool
  })
  description = "Target group sticky configuration"
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}


variable "create_instance" {
  description = "Whether to create an EC2 instance"
  type        = bool
  default     = true
}

variable "instance_target_group_port" {
  type        = number
  description = "The port for the default target group"
}
variable "sgs" {
  type = map(object({
    name        = string
    description = string
    ingress_rules = map(object({
      description       = optional(string)
      from_port         = number
      to_port           = number
      protocol          = string
      cidr_blocks       = optional(list(string))
      security_group_id = optional(list(string))
      ipv6_cidr_blocks  = optional(list(string))
      self              = optional(bool)
    }))
    egress_rules = map(object({
      description       = optional(string)
      from_port         = number
      to_port           = number
      protocol          = string
      cidr_blocks       = optional(list(string))
      security_group_id = optional(list(string))
      ipv6_cidr_blocks  = optional(list(string))
    }))
    create_security_group = bool
  }))
  description = "Security group ingress/egress configuration"
  default     = {}
}