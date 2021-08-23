# locals {

#   functions = merge(
#     var.functions, {

#      vpcs  = var.vpcs
#     }
#   )
# }
locals {

  functions = merge(
    var.serverless.functions, {

   
    }
  )
}
