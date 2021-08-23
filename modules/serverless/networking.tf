output "vpcs" {

  value = module.networking
}

resource "random_pet" "this" {
  length = 2
}

module "networking" {
  #   depends_on = []

  source   = "terraform-aws-modules/vpc/aws"
  for_each = local.networking.vpcs
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

variable "networking" {

  default = {
networking = {
      vpcs = {

      db_vpc = {

        cidr            = "10.10.0.0/16"
        azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]

        # Add public_subnets and NAT Gateway to allow access to internet from Lambda
        public_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
        enable_nat_gateway = true


      }
      app_vpc = {

        cidr            = "10.11.0.0/16"
        azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

        # Add public_subnets and NAT Gateway to allow access to internet from Lambda
        public_subnets     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
        enable_nat_gateway = false


      }
    }
}
  }

}
