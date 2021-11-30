locals {

  api_gateways = merge(try(var.serverless.api_gateways, {}), {})
  api_integrations = merge(try(var.serverless.api_integrations,{}),{})
}
