
locals {
  functions = merge(try(var.serverless.lambda_layers, {}), {})
}
