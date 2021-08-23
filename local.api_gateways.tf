locals {

  api_gateways = merge(
    var.serverless.api_gateways, {
     integrations  = var.integrations
    }
  )
}
