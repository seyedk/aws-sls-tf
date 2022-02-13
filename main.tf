module "aws_sls_model" {

  source = "./aws"

  api_gateways = try(local.api_gateways, {})
  functions    = try(local.functions, {})
  vpcs         = try(local.vpcs, {})
  #  static_websites        = local.static_websites
  #  dynamodb_tables        = local.ddb_tables
  global_settings = local.global_settings


  # tfstates = try(var.serverless.tfstates,{})

  tags           = local.tags
  remote_objects = local.remote

  current_serverless_key = var.serverless.key
  api_integrations       = try(local.api_integrations, {})
  client_config          = {}

  cognito_userpools = try(local.cognito_userpools, {})

  # todo: the following line would add cloudfront and dynamodb tables

  # cloud_fronts = local.cloud_front_distributions
  # todo: the following line would add cloudfront and dynamodb tables
  dynamodb_tables = try(local.dynamodb_tables, {})
  step_functions  = try(local.step_functions, {})

  acms          = try(local.acms, {})
  s3_buckets    = try(local.s3_buckets, {})
  lambda_layers = try(local.lambda_layers, {})

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
