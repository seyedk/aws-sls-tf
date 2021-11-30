locals {

  serverless = {

    current = {

      s3_bucket_name = var.serverless.tfstate_bucket_name
    }
    # lower = {

    #   s3_bucket_name = var.tfstate_bucket_name
    # }
  }
}

data "terraform_remote_state" "remote" {
  for_each = try(var.serverless.tfstates, {})

  backend = var.serverless.backend_type
  config  = local.remote_state[try(each.value.backend_type, var.serverless.backend_type, "s3")][each.key]

}

locals {

  remote_state = {

    s3 = {
      for key, value in try(var.serverless.tfstates, {}) : key => {
        bucket         = var.serverless.tfstate_bucket_name
        key            = value.tfstate
        region         = value.region
        dynamodb_table = value.dynamodb_table
        encrypt        = true


      }
    }
    


  }

  global_settings = try(var.serverless.global_settings,{})
}


# output "all_remote_states" {
#   value = {
#     for key, value in data.terraform_remote_state.remote : key => value
#   }
# }


## data.terraform_remote_state.db.outputs.address
## db_port     = data.terraform_remote_state.db.outputs.port

# output "db_addresss" {
#     value = data.terraform_remote_state.remote["database"].outputs.address
# }

# output "db_port" {
#     value = data.terraform_remote_state.remote["database"].outputs.port
# }

# output "app_ssm_ps" {
#     value = data.terraform_remote_state.remote["app"].outputs.parameter_store_name
# }

# output "app_objects" {
#   value = data.terraform_remote_state.remote["app"].outputs.objects
# }
