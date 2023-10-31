variable "name" {
  type        = string
  description = "The name of the policy. If omitted, Terraform will assign a random, unique name."
}

variable "create_aws_iam_policy" {
  type        = bool
  description = "A boolean indicates wether to create aws iam policy or not"
}

variable "policy_statement" {
  type = list(object({
    Sid       = optional(string)
    Action    = list(string)
    Resource  = list(string)
    Effect    = string
    Condition = optional(any, {})
  }))
  description = "List of objects described to create customer managed policies"
}

variable "description" {
  type        = string
  description = "Description of the IAM policy"
}
