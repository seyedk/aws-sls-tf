locals {

  api_gateways = merge(try(var.serverless.api_gateways, {}), {})
}
