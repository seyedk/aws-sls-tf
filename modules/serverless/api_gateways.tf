module "api_gateways" {
  # depends_on = [
  #   module.functions
  # ]
  source = "terraform-aws-modules/apigateway-v2/aws"
  for_each = local.api_gateways

  name          = each.value.name
  description   = each.value.description
  protocol_type = each.value.protocol_type

  cors_configuration = each.value.cors_configuration

  # Custom domain
  domain_name                 = each.value.domain_name
  domain_name_certificate_arn = each.value.domain_name_certificate_arn

  # # Access logs
  default_stage_access_log_destination_arn = each.value.default_stage_access_log_destination_arn
  default_stage_access_log_format          = each.value.default_stage_access_log_format


  # Routes and integrations
#   integrations = local.integartions[each.key]
  

  tags = each.value.tags
}

output "api_gateways" {
  value = module.api_gateways
}
