
locals {
  functions = merge(try(var.serverless.s3_buckets, {}), {})
}
