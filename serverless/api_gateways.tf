module "api_gateways" {
  # depends_on = [
  #   module.functions
  # ]
  source   = "terraform-aws-modules/apigateway-v2/aws"
  for_each = local.api_gateways

  name          = each.value.name
  description   = each.value.description
  protocol_type = each.value.protocol_type

  cors_configuration = each.value.cors_configuration

  # Custom domain
  domain_name                 = try(each.value.domain_name, null)
  domain_name_certificate_arn = try(each.value.domain_name_certificate_arn, null)

  # # Access logs
  default_stage_access_log_destination_arn = try(each.value.default_stage_access_log_destination_arn, null)
  default_stage_access_log_format          = try(each.value.default_stage_access_log_format,null)
  create_api_domain_name                   = false # to control creation of API Gateway Domain Name
  create_default_stage                     = false # to control creation of "$default" stage
  create_default_stage_api_mapping         = false # to control creation of "$default" stage and API mapping
  create_routes_and_integrations           = true # to control creation of routes and integrations
  create_vpc_link                          = false # to control creation of VPC link


  # Routes and integrations
  integrations = local.integrations[each.key]
  


  tags = each.value.tags
}

output "api_gateways" {
  value = module.api_gateways
}
