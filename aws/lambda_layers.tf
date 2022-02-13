

## this function is called to create functions, and if a layer
## is needed, it should be created in Lambda Layer Module. 
module "lambda_layers" {
  source   = "terraform-aws-modules/lambda/aws"
  for_each = local.lambda_layers




  create_layer = true

  layer_name          = each.key
  description         = each.value.description
  compatible_runtimes = each.value.compatible_runtimes

  source_path = each.value.source_path

  # store_on_s3 = true
  # s3_bucket   = "my-bucket-id-with-lambda-builds"

}


output "lambda_layers" {
  value = module.lambda_layers
}
