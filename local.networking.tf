locals {

  vpcs = merge(try(var.serverless.vpcs,{}),{})
  
  
}

