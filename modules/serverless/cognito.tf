module "cognito_userpools" {

  source         = "lgallard/cognito-user-pool/aws"
  for_each       = local.cognito_userpools
  user_pool_name = each.key

  # tags
  tags = each.value.tags
}

output "cognito_userpools" {
    sensitive = true
    value = module.cognito_userpools
}
