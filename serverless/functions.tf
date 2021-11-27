

## this function is called to create functions, and if a layer
## is needed, it should be created in Lambda Layer Module. 
module "functions" {
  source   = "terraform-aws-modules/lambda/aws"
  for_each = local.functions
  depends_on = [
    module.vpcs, module.lambda_layers
  ]

  function_name          = each.value.function_name
  description            = each.value.description
  handler                = each.value.handler
  runtime                = each.value.runtime
  source_path            = each.value.source_path
  tags                   = each.value.tags
  vpc_subnet_ids         = local.vpc_info[each.key].vpc_subnet_ids
  vpc_security_group_ids = [local.vpc_info[each.key].vpc_security_group_ids]
  attach_network_policy  = true
  publish = true
  # allowed_triggers = try(each.value.allowed_triggers, {})
  allowed_triggers = try(local.allowed_triggers[each.key])

  layers = local.lambda_layers[each.key]
  

}


output "functions" {
  value = module.functions
}
