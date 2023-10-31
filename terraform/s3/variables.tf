variable "s3_buckets" {
  type = list(object({
    bucket_name            = string
    bucket_key_enabled     = bool
    allowed_bucket_actions = list(string)
    acl                    = string
    force_destroy          = bool
    versioning_enabled     = bool
    block_public_acls      = bool
    cors_configuration = list(object({
      allowed_headers = list(string)
      allowed_methods = list(string)
      allowed_origins = list(string)
      expose_headers  = list(string)
      max_age_seconds = number
    }))
    lifecycle_configuration_rules = list(object({
      abort_incomplete_multipart_upload_days = number
      enabled                                = bool
      expiration = object({
        days                         = number
        expired_object_delete_marker = bool
      })
      filter_and = object({})
      id         = string
      noncurrent_version_expiration = object({
        newer_noncurrent_versions = number
        noncurrent_days           = number
      })
      noncurrent_version_transition = list(object({}))
      transition = list(object({
        days          = number
        storage_class = string
      }))
    }))
    website_configuration = list(object({
      index_document = string
      error_document = string
      routing_rules = list(object({
        condition = object({
          http_error_code_returned_equals = string
          key_prefix_equals               = string
        })
        redirect = object({
          host_name               = string
          http_redirect_code      = string
          protocol                = string
          replace_key_prefix_with = string
          replace_key_with        = string
        })
      }))
    }))
    access_key_enabled = bool
  }))
}

variable "project_name" {
  type        = string
  description = "Name of the project."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}


variable "region" {
  type        = string
  default     = ""
  description = "If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee"
}

variable "allow_encrypted_uploads_only" {
  type        = bool
  default     = false
  description = "Set to `true` to prevent uploads of unencrypted objects to S3 bucket"
}

variable "user_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to create an IAM user with permission to access the bucket"
}