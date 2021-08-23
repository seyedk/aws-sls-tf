data "aws_caller_identity" "current" {}

resource "random_string" "prefix" {
  count   = try(var.global_settings.prfix, null) == null ? 1 : 0
  length  = 6
  special = false
  upper   = false
  number  = false
}

locals {
  client_config = var.client_config == {} ? {

    serverless_key = var.current_serverless_key
    caller_user    = data.aws_caller_identity.current.user_id
    caller_arn     = data.aws_caller_identity.current.arn
    aws_account_id = data.aws_caller_identity.current.account_id
  } : map(var.client_config)



  networking = {

    vpcs = try(var.networking.vpcs, {})
    albs = try(var.networking.albs, {})
    elbs = try(var.networking.elbs, {})
  }
  functions =try(var.functions, {})
}

