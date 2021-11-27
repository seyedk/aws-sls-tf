module "s3_buckets" {
  # depends_on = [
  #   module.functions
  # ]
  source   = "terraform-aws-modules/terraform-aws-s3-bucket/aws"
  for_each = local.s3_buckets



  bucket        = each.value.bucket_name
  acl           = each.value.acl #private or public
  force_destroy = true

  attach_policy = true
  policy        = try(each.value.bucket_policy, null)

  attach_deny_insecure_transport_policy = each.value.attach_deny_insecure_transport_policy

  tags = each.value.tags
  versioning = each.value.versioning_enabled

  website = each.value.website

  logging = each.value.logging

  cors_rule =try(each.value.cors_rule, [])

  lifecycle_rule = try(each.value.lifecycle_rule, [])

  server_side_encryption_configuration = try(each.value.server_side_encryption_configuration, {})

  object_lock_configuration = try(each.value.object_lock_configuration, {})

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Bucket Ownership Controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"
}

output "s3_buckets" {
  value = module.s3_buckets
}
