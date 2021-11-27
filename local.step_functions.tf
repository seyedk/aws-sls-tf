
locals {
  step_functions = merge(try(var.serverless.step_functions, {}), {})
}
