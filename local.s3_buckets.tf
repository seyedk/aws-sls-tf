
locals {
  s3_buckets = merge(try(var.serverless.s3_buckets, {}), {})
}
