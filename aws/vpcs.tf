

resource "random_pet" "this" {
  length = 2
}

module "vpcs" {
  #   depends_on = []

  source   = "terraform-aws-modules/vpc/aws"
  for_each = try(local.vpcs, {})
  #todo: do we want to add the security groups here? I guess so!
  #   security_groups = module.security_groups

  tags          = try(each.value.tags, null)
  name          = each.key
  cidr          = each.value.cidr
  azs           = each.value.azs
  intra_subnets = each.value.private_subnets

  # Add public_subnets and NAT Gateway to allow access to internet from Lambda
  public_subnets     = each.value.public_subnets
  enable_nat_gateway = each.value.enable_nat_gateway

}

variable "vpcs" {

  default = {}

}


output "vpcs" {
  value = module.vpcs
}