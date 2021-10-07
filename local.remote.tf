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

        cognito_userpools = {
             for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].cognito_userpools,{}))
        }
        eks_clusters = {

            for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].eks_cluster,{}))
        }

        
    }
}

output "ztest_delete_me" {
    value = local.remote.vpcs
}