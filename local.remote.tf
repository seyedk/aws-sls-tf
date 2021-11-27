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
        # eks_clusters = {

        #     for key, value in try(var.serverless.tfstates,{}): key => merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].eks_cluster,{}))
        # }
        step_functions = {
            for key, value in try(var.serverless.tfstates,{}): key=> merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].step_functions))
        }
        dynamodb_tables = {
            for key, value in try(var.serverless.tfstates,{}): key=> merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].dynamodb_tables))
        }
        acms = {
            for key, value in try(var.serverless.tfstates,{}): key=> merge(try(data.terraform_remote_state.remote[key].outputs.objects[key].acms))
        }

        
    }
}

output "remote_info_vpcs" {
    value = local.remote.vpcs
}
output "remote_info_functions" {
    value = local.remote.functions
}
output "remote_info_api_gateways" {
    value = local.remote.api_gateways
}
output "remote_info_cognito_userpools" {
    value = local.remote.cognito_userpools
}
output "remote_info_step_functions" {
    value = local.remote.step_functions
}
output "remote_info_vpcs" {
    value = local.remote.vpcs
}
output "remote_info_dynamodb_tables" {
    value = local.remote.dynamodb_tables
}
output "remote_info_acms" {
    value = local.remote.acms
}