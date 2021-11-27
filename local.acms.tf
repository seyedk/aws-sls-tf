locals {

  api_gateways = merge(
    try(var.serverless.acms,{}), {
     
    }
  )
}
