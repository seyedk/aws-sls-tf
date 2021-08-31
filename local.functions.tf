# locals {

#   functions = merge(
#     var.functions, {

#      vpcs  = var.vpcs
#     }
#   )
# }
locals {

  functions = merge(
    try(var.serverless.functions,{}), {
  
    }
  )
}
