
locals {
  lambda_layers = merge(try(var.serverless.lambda_layers, {}), {})
}
