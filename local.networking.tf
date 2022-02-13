locals {

  vpcs = merge(try(var.vpcs, {}), {})


}

