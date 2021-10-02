locals  {

    remote = {

        vpcs = {
            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].vpcs,{}))
        }
        functions = {
            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].functions,{}))
        }

        api_gateways = {
            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].api_gateways,{}))
        }

        
    }
}

output "z_delete_me" {
    value = local.remote.vpcs
}