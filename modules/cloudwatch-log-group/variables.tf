variable "cloudwatch_log_group" {
  type = list(object({
    name              = string
    retention_in_days = optional(number, 0)
    kms_key_id        = optional(string, null)
  }))
  description = "The name of the log group"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource"
}
