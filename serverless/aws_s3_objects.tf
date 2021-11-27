module "s3_buckets" {
  # depends_on = [
  #   module.functions
  # ]
  source   = "terraform-aws-modules/terraform-aws-s3-object/aws"
  for_each = local.s3_bucket_objects


  bucketname = each.value.bucket_name
  sourceFile = "test.txt"
  destFileName = "test-1.txt"

}

output "s3_buckets" {
  value = module.s3_buckets
}
