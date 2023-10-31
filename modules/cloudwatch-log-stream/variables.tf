variable "cloudwatch_log_stream" {
  type = list(object({
    name           = string
    log_group_name = string
  }))
  description = "This parameter is used to create cloudwatch log stream"
}
