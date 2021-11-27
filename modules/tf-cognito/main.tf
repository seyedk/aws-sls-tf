provider "aws" {
  alias = "deployment"
}

data "aws_region" "current" {
  provider = aws.deployment
}

module "pre_token_lambda" {
  source           = "../tf-lambda"
  deployment_label = var.deployment_label
  function_name    = "${var.user_pool_name}-pre-token-enrichment"
  tags             = var.tags
  file_path        = var.pre_token_lambda_package_path
  handler_name     = var.pre_token_lambda_handler_name
  memory_size      = var.memory_size
  runtime          = var.runtime
  timeout          = var.timeout

  vpc_config = var.vpc_config

  environment_settings = {
    COGNITO_USERPOOL_PATH            = var.userpool_path
  }

  providers = {
    aws.deployment = aws.deployment
  }
}

resource "aws_cognito_user_pool" "user_pool" {
  provider = aws.deployment

  name              = join("-", compact([var.user_pool_name, var.deployment_label]))
  mfa_configuration = "OFF"
  auto_verified_attributes = [
    "email",
  ]

  dynamic "schema" {
    for_each = length(var.custom_schemas) == 0 ? {} : { for s in var.custom_schemas : join(".", compact([
      s.name,
      s.attribute_data_type
      ])) => s
    }

    content {
      name                = schema.value.name
      attribute_data_type = schema.value.attribute_data_type
      required            = schema.value.required
      mutable             = schema.value.mutable

      dynamic "string_attribute_constraints" {
        for_each = schema.value.attribute_data_type == "String" ? [{ "content" : "String" }] : []
        content {
          min_length = 1
          max_length = 256
        }
      }
    }
  }

# TODO: Create dynamic block to change event lambda fires on
  lambda_config {
    pre_token_generation = module.pre_token_lambda.lambda_output.lambda_arn
  }

  tags = var.tags
}

resource "aws_lambda_permission" "allow_userpool" {
  provider      = aws.deployment
  statement_id  = "allow_cognito_userpool"
  action        = "lambda:InvokeFunction"
  function_name = module.pre_token_lambda.lambda_output.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user_pool.arn
}

// sets the alias portion of the default cognito url, necessary for OIDC redirects
resource "aws_cognito_user_pool_domain" "user_pool" {
  provider     = aws.deployment
  domain       = aws_cognito_user_pool.user_pool.name
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

# read by frontend deployment
resource "aws_ssm_parameter" "user_pool_authorize_endpoint" {

  provider = aws.deployment

  name      = "/${var.application_name}/${join("_", compact(["user_pool_authorize_endpoint", var.deployment_label]))}"
  type      = "String"
  value     = "https://${aws_cognito_user_pool.user_pool.name}.auth.${data.aws_region.current.name}.amazoncognito.com/oauth2"
  overwrite = true

  tags = var.tags
}

resource "aws_ssm_parameter" "user_pool_id" {

  provider = aws.deployment

  name      = "/${var.application_name}/userpool_id"
  type      = "String"
  value     = aws_cognito_user_pool.user_pool.id
  overwrite = true

  tags = var.tags
}

resource "aws_cognito_identity_provider" "identity_provider" {

  provider = aws.deployment

  for_each = {
    for identity_provider in var.providers_mapping : join(".", compact([
      identity_provider.name,
      identity_provider.type,
    ])) => identity_provider
  }


  user_pool_id  = aws_cognito_user_pool.user_pool.id
  provider_name = each.value.name
  provider_type = each.value.type
  provider_details = {
    client_id                 = each.value.client_id
    client_secret             = each.value.client_secret
    authorize_scopes          = each.value.authorize_scopes
    attributes_request_method = each.value.attributes_request_method
    oidc_issuer               = each.value.oidc_issuer
  }
  attribute_mapping = each.value.attribute_mapping
}