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


  # todo: uncomment the following lines to add the resource
  # cloud_front_distributions = try(var.cloudfront_distributions, {})


  dynamodb_tables = try(var.dynamodb_tables, {})
  step_functions  = try(var.step_functions, {})
  acms            = try(var.acms, {})

  s3_buckets = try(var.s3_buckets, {})

  lambda_layers = try(var.lambda_layers, {})

  api_integrations = try(var.api_integrations, {})
}

locals {

  integrations = {


    for key, value in local.api_integrations :


    key => merge(

     
      try(value.api_key, {}) == {} ? {} : { api_id = local.combined_objects_api_gateways[value.api_layer_key][value.api_key].apigatewayv2_api_id },
      try(value.function_key, {}) == {} ? {} : { lambda_arn = local.combined_objects_functions[value.layer_key][value.function_key].lambda_function_arn },
      try(value.authorization_type, {}) == {} ? {} : { authorization_type = value.authorization_type },
      try(value.payload_format_version, {}) == {} ? {} : { payload_format_version = value.payload_format_version },
      try(value.timeout_milliseconds, {}) == {} ? {} : { timeout_milliseconds = value.timeout_milliseconds },
      try(value.credentials_arn, {}) == {} ? {} : { credentials_arn = value.credentials_arn },
      try(value.authorizer_id, {}) == {} ? {} : { authorizer_id = value.authorizer_id },
      try(value.request_parameters, {}) == {} ? {} : { request_parameters = jsonencode(value.request_parameters) },
      try(value.response_parameters, {}) == {} ? {} : { response_parameters = jsonencode(value.response_parameters) },
     
    )


  }
}
locals {
  allowed_triggers = {

    for fkey, fvalue in local.functions :
    fkey => {
      for key, value in fvalue.allowed_triggers :
      key => {
        service    = value.service
        source_arn = "${local.combined_objects_api_gateways[value.layer_key][value.api_key].apigatewayv2_api_execution_arn}/*/*"

      }
    }

  }
}


locals {

  vpc_info = {
    for f_key, f_value in local.functions :

    f_key => {
      vpc_subnet_ids         = lookup(f_value, "vpc_info", null) == null ? null : local.combined_objects_vpcs[f_value.vpc_info.layer_key][f_value.vpc_info.vpc_key][f_value.vpc_info.subnet_key]
      vpc_security_group_ids = lookup(f_value, "vpc_info", null) == null ? null : local.combined_objects_vpcs[f_value.vpc_info.layer_key][f_value.vpc_info.vpc_key]["default_security_group_id"]
    }
  }
}


