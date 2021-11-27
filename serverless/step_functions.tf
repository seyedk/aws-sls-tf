module "step_functions" {
  source  = "terraform-aws-modules/step-functions/aws"
  for_each = local.step_functions
  version = "~> 2.0"

  name = each.value.name

  definition = each.value.definition
}

output "functions" {
  value = module.step_functions
}
