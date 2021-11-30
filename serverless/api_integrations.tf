module "api_integrations" {
  depends_on = [
    module.functions, module.api_gateways
  ]
  source   = "./modules/api_integrations"


 


  # Routes and integrations
   api_integrations = local.integrations

   # Routes to come in soon! 



}

output "api_integrations" {
  value = module.api_integrations
}
