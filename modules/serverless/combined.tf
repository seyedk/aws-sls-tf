locals {

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

  combined_objects_api_gateways = merge(
    tomap(
      {
        (local.client_config.serverless_key) = module.api_gateways
      }),
      try(var.remote_objects.api_gateways)
    
  )
}

output "combined_objects_functions" {
  value = local.combined_objects_functions
  
}

output "combined_objects_apigateway" {
  value = local.combined_objects_api_gateways
}

output "combined_objects_vpcs" {
  value = local.combined_objects_vpcs

}

