locals {

  combined_objects_networking = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.networking
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

  combined_objects_api_gateways = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.api_gateways
      }),
      try(var.remote_objects.api_gateways)
    
  )
}

output "remote_objects_functions" {
  value = local.combined_objects_functions
  
}

output "remote_objects_apigateway" {
  value = local.combined_objects_api_gateways
}

