variable "iam_role" {
  type = list(object({
    role_name             = string
    assume_role_names     = list(string)
    aws_assume_role_names = optional(list(string), [])
    inline_policy = list(object({
      name = string
      Statement = list(object({
        Action    = any
        Effect    = any
        Resource  = any
        Condition = optional(any, {})
      }))
    }))
  }))
  description = "Service Role used for the codebuild project"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Default tags to apply to every resource"
}

variable "aws_managed_policy_names" {
  type        = list(string)
  description = "List of names for aws managed policies to be attached to the role"
  default     = []
}
