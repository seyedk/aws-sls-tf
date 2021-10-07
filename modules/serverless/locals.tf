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



  vpcs = try(var.vpcs, {})


  functions    = try(var.functions, {})
  api_gateways = try(var.api_gateways, {})

   cognito_userpools = try(var.cognito_userpools, {})
}


locals {
  integrations = {
    for api_key, api_value in local.api_gateways :
    api_key => {
      for key, value in api_value.integrations :
      key => {
        lambda_arn             = local.combined_objects_functions[value.service_name][value.function_name].lambda_function_arn
        payload_format_version = value.payload_format_version
        timeout_milliseconds   = value.timeout_milliseconds
      }
    }


  }

}


# locals {
#   cognito_userpools_integration = local.combined_objects_cognito_userpools

# }


locals {

  vpc_info = {
    for f_key, f_value in local.functions :

    f_key => {
      vpc_subnet_ids         = lookup(f_value, "vpc_info", null) == null ? null : local.combined_objects_vpcs[f_value.vpc_info.layer_key][f_value.vpc_info.vpc_key][f_value.vpc_info.subnet_key]
      vpc_security_group_ids = lookup(f_value, "vpc_info", null) == null ? null : local.combined_objects_vpcs[f_value.vpc_info.layer_key][f_value.vpc_info.vpc_key]["default_security_group_id"]
    }
  }
}
output "my_vpc_info" {
  value = local.vpc_info
}

output "lambda_integrations" {
  value = local.integrations
}

# output "cognito_userpools_integration" {
#   value = local.cognito_userpools_integration
# }
