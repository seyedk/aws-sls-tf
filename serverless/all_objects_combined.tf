locals {

  combined_objects_cognito_userpools = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.cognito_userpools
      }
    ),
    try(var.remote_objects.cognito_userpools, {})
  )
  # todo: use the pattern below to add a combined resource
  combined_objects_dynamodb_tables = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.dynamodb_tables
      }
    ),
    try(var.remote_objects.dynamodb_tables, {})
  )

  #  combined_objects_cloudfront_distributions = merge(
  #   tomap(
  #     {
  #       (local.client_config.serverless_key) = module.cloudfront_distributions
  #     }
  #   ),
  #   try(var.remote_objects.cloudfront_distributions, {})
  # )
  combined_objects_vpcs = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.vpcs
      }
    ),
    try(var.remote_objects.vpcs, {})
  )
  combined_objects_functions = merge(

    tomap(
      {
        (local.client_config.serverless_key) = module.functions
    }),
    try(var.remote_objects.functions)

  )
  combined_objects_step_functions = merge(
    tomap({
      (local.client_config.serverless_key) = module.step_functions
    }),
    try(var.remote_objects.step_functions)
  )

  combined_objects_acms = merge(
    tomap({
      (local.client_config.serverless_key) = module.acms
    }),
    try(var.remote_objects.acms)
  )


  combined_objects_api_gateways = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.api_gateways
    }),
    try(var.remote_objects.api_gateways)

  )
}

# output "combined_objects_functions" {
#   value = local.combined_objects_functions

# }

# output "combined_objects_apigateway" {
#   value = local.combined_objects_api_gateways
# }

# output "combined_objects_vpcs" {
#   value = local.combined_objects_vpcs

# }

# output "combined_objects_step_functions" {
#   value = local.combined_objects_step_functions
# }

