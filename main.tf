module "aws_sls_model" {

  source = "./serverless"

  functions    = local.functions
  api_gateways = local.api_gateways
  vpcs   = local.vpcs
  #  static_websites        = local.static_websites
  #  dynamodb_tables        = local.ddb_tables
  global_settings = local.global_settings

  
  # tfstates = try(var.serverless.tfstates,{})

  tags           = local.tags
  remote_objects = local.remote

  current_serverless_key = var.serverless.key
  integrations           = {}
  client_config          = {}

  cognito_userpools = local.cognito_userpools

  # todo: the following line would add cloudfront and dynamodb tables

  # cloud_fronts = local.cloud_front_distributions
  # todo: the following line would add cloudfront and dynamodb tables
   dynamodb_tables = local.dynamodb_tables
   step_functions = local.step_functions

   acms = local.acms
   s3_buckets = local.s3_buckets
   lambda_layers = local.lambda_layers
  # s3_bucket_objects = local.s3_bucket_objects



}

output "objects" {
  sensitive = true
  value = tomap(
    {
      (var.serverless.key) = {
        for key, value in module.aws_sls_model : key => value
        if try(value, {}) != {}
      }
    }
  )

}
