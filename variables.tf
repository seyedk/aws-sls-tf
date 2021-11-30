variable "global_settings" {
  default = {}

}

variable "client_config" {

  default = {}
}

variable "current_serverless_key" {
  default = "default"

}




variable "remote_objects" {
  default = {}

}

# variable "tfstate_bucket_name" {} 
variable "vpcs" {
  default = {}
}

variable "serverless" {}

variable "api_gateways" {
  default = {}
}


variable "api_integrations" {
  default = {

  

  }
}

variable "cognito_userpools" {

  default = {}
}

variable "step_functions" {
  default = {}
}
variable "dynamodb_tables" {
  default = {}
}
