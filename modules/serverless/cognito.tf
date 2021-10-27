module "cognito_userpools" {

  source         = "lgallard/cognito-user-pool/aws"
  for_each       = local.cognito_userpools
  user_pool_name = each.key

  # tags



  alias_attributes                                   = try(each.value.alias_attributes, [])
  auto_verified_attributes                           = try(each.value.auto_verified_attributes, [])
  sms_authentication_message                         = try(each.value.sms_authentication_message, "***PLEASE UPDATE Message {####}***")
  sms_verification_message                           = try(each.value.sms_verification_message, "***PLEASE UPDATE Message {####}***")
  lambda_config_verify_auth_challenge_response       = try(each.value.lambda_config_verify_auth_challenge_response, "")
  password_policy_require_lowercase                  = try(each.value.password_policy_require_lowercase, false)
  password_policy_minimum_length                     = try(each.value.password_policy_minimum_length, 12)
  user_pool_add_ons_advanced_security_mode           = try(each.value.user_pool_add_ons_advanced_security_mode, "OFF")
  client_prevent_user_existence_errors               = try(each.value.client_prevent_user_existence_errors, "LEGACY")
  verification_message_template_default_email_option = try(each.value.verification_message_template_default_email_option, "CONFIRM_WITH_CODE")

  # schemas
  schemas = try(each.value.schemas, [])

  string_schemas = try(each.value.string_schemas, [])

  # user_pool_domain
  domain = try(each.value.domain, "")

  # client
  client_name                                 = try(each.value.client_name, "")
  client_allowed_oauth_flows_user_pool_client = try(each.value.client_allowed_oauth_flows_user_pool_client, false)
  client_callback_urls                        = try(each.value.client_callback_urls, [])
  client_default_redirect_uri                 = try(each.value.client_default_redirect_uri, "")
  client_read_attributes                      = try(each.value.client_read_attributes, [])
  client_refresh_token_validity               = try(each.value.client_refresh_token_validity, 30)


  # user_group
  user_group_name        = try(each.value.user_group_name, "")
  user_group_description = try(each.value.user_group_description, "")

  # ressource server
  resource_server_identifier        = try(each.value.resource_server_identifier, "")
  resource_server_name              = try(each.value.resource_server_name, "")
  resource_server_scope_name        = try(each.value.resource_server_scope_name, "")
  resource_server_scope_description = try(each.value.resource_server_scope_description, "")

  # tags
  tags = try(each.value.tags, {})

}

output "cognito_userpools" {
  sensitive = true
  value     = module.cognito_userpools
}
