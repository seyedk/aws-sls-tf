module "dynamodb_tables" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  for_each = local.dynamodb_tables

  name      = each.value.table_name
  hash_key  = each.value.hash_key
  range_key = each.value.range_key

  attributes = each.value.attributes

  global_secondary_indexes = each.value.global_secondary_indexes

  tags = each.value.tags
}

output "dynamodb_tables" {
    value = module.dynamodb_tables
}
