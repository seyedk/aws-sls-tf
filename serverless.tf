module "sls_app1" {

  source          = "./modules/serverless"
  functions       = local.functions
   api_gateways    = local.api_gateways
#   ddb_tables      = local.ddb_tables
  global_settings = local.global_settings

#   websites = local.websites
  tfstates = var.serverless.tfstates

  tags           = local.tags
  remote_objects = local.remote

  networking             = local.networking
  current_serverless_key = var.serverless.key
  integrations = {}
  client_config = {}

}

output "objects" {
  value = tomap(
    {
      (var.serverless.key) = {
        for key, value in module.sls_app1: key => value
        if try(value , {}) != {}
      }
    }
  )
  
}
