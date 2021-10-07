locals {

  cognito_userpools = merge(try(var.serverless.cognito_userpools, {}), {})


}

