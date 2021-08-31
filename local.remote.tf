locals  {

    remote = {

        networking = {
            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].networking,{}))
        }
        functions = {
            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].functions,{}))
        }

        api_gateways = {
            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].api_gateways,{}))
        }
        
    }
}