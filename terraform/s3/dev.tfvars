region                       = "eu-west-2"
project_name                 = "Property-Collection"
environment                  = "dev"
allow_encrypted_uploads_only = false
user_enabled                 = false
s3_buckets = [
  {
    bucket_name            = "cms-201506-media"
    bucket_key_enabled            = true
    allowed_bucket_actions        = []
    acl                           = "private"
    force_destroy                 = false
    block_public_acls             = true
    versioning_enabled            = false
    lifecycle_configuration_rules = []
    website_configuration         = []
    cors_configuration            = []

    access_key_enabled = false
  },
  {
    bucket_name            = "voiceovermusic"
    bucket_key_enabled            = true
    allowed_bucket_actions        = []
    acl                           = "private"
    force_destroy                 = false
    block_public_acls             = true
    versioning_enabled            = false
    lifecycle_configuration_rules = []
    website_configuration         = []
    cors_configuration            = []

    access_key_enabled = false
  },
  {
    bucket_name            = "propertycollection-cms-media"
    bucket_key_enabled            = true
    allowed_bucket_actions        = []
    acl                           = "private"
    force_destroy                 = false
    block_public_acls             = true
    versioning_enabled            = false
    lifecycle_configuration_rules = []
    website_configuration         = []
    cors_configuration            = []

    access_key_enabled = false
  },
  {
    bucket_name            = "pygott-and-crone"
    bucket_key_enabled            = true
    allowed_bucket_actions        = []
    acl                           = "private"
    force_destroy                 = false
    block_public_acls             = true
    versioning_enabled            = false
    lifecycle_configuration_rules = []
    website_configuration         = []
    cors_configuration            = []

    access_key_enabled = false
  },
  {
    bucket_name            = "property-collection-dev"
    bucket_key_enabled            = true
    allowed_bucket_actions        = []
    acl                           = "private"
    force_destroy                 = false
    block_public_acls             = true
    versioning_enabled            = false
    lifecycle_configuration_rules = []
    website_configuration         = []
    cors_configuration            = []

    access_key_enabled = false
  }
]