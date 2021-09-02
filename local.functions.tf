
locals {

  functions = merge(
    try(var.serverless.functions,{}), {
  
    }
  )
}
