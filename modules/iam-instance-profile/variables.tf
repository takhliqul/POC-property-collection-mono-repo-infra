variable "iam_instance_profile" {
  type = list(object({
    name          = string
    iam_role_name = string
  }))
  description = "This parameter is used to create IAM instance profile"
}

variable "tags" {
  type        = map(string)
  description = "Default tags to apply to every resource"
}