
module "functions" {
  source   = "terraform-aws-modules/lambda/aws"
  for_each = local.functions

  function_name = each.value.function_name
  description   = each.value.description
  handler       = each.value.handler
  runtime       = each.value.runtime
  source_path   = each.value.source_path
  tags          = each.value.tags


## todo: fix this line
  # vpc_subnet_ids = lookup(each.value, "sls_key", null) == null ? local.combined_objects_networking[local.client_config.serverless_key][each.value.vpc_key].subnets : local.combined_objects_networking[each.value.sls_key][each.value.vpc_key].subnets

  # vpc_security_group_ids = [for vpc in module.networking : vpc.default_security_group_id]


  attach_network_policy = true
}


output "sls_lambdas" {
  value = module.functions
}
