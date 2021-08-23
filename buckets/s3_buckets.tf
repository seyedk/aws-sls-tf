resource "aws_s3_bucket" "s3_buckets" {
  for_each = try(var.s3_buckets, {})


  bucket = "${each.value.name_prefix}-${each.key}"

  // This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production
  // usage
  force_destroy = each.value.force_destroy

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = each.value.version_enabled
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = each.value.sse_algorithm
      }
    }
  }
}




output "aws_s3_buckets" {

  value = aws_s3_bucket.s3_buckets
}

