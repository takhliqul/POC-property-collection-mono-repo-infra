
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags?ref=1.2.1"

  environment = var.environment
  project     = var.project_name

}

module "s3_bucket" {

  source = "git::https://github.com/cloudposse/terraform-aws-s3-bucket?ref=3.1.2"

  for_each                      = { for x in var.s3_buckets : x.bucket_name => x }
  lifecycle_configuration_rules = each.value.lifecycle_configuration_rules
  bucket_name                   = each.value.bucket_name
  bucket_key_enabled            = each.value.bucket_key_enabled
  allowed_bucket_actions        = each.value.allowed_bucket_actions
  user_enabled                  = var.user_enabled
  block_public_acls             = each.value.block_public_acls
  acl                           = each.value.acl
  force_destroy                 = each.value.force_destroy
  versioning_enabled            = each.value.versioning_enabled
  allow_encrypted_uploads_only  = var.allow_encrypted_uploads_only
  access_key_enabled            = each.value.access_key_enabled
  website_configuration         = each.value.website_configuration
  cors_configuration            = each.value.cors_configuration

  tags = module.tags.tags
}