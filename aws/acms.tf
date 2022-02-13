module "acms" {
  source   = "terraform-aws-modules/acm/aws"
  for_each = local.acms
  version  = "~> 3.0"

  domain_name = each.value.domain_name
  zone_id     = each.value.zone_id

  subject_alternative_names = each.value.subject_alternative_names

  wait_for_validation = each.value.wait_for_validation

  tags = each.value.tags
}

output "acms" {
  value = module.acms
}