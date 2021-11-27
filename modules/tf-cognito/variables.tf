variable "application_name" {
  type        = string
  description = "Application Name"
}
variable "tags" {
  type        = map(string)
  description = "required tags"
}

variable "user_pool_name" {
  type        = string
  description = "name of cognito user pool"
}

variable "pre_token_lambda_package_path" {
  type        = string
  description = "file path to pre-token cognition claim enrichment lambda"
}

variable "pre_token_lambda_handler_name" {
  type        = string
  description = "handler to pre-token cognition claim enrichment lambda"
}

variable "memory_size" {
  type    = number
  default = 256
}

variable "runtime" {
  type    = string
  default = "dotnetcore3.1"
}

variable "timeout" {
  type    = number
  default = 30
}

variable "deployment_label" {
  type = string
}
variable "userpool_path" {
  description = "Cognito Userpool Path"
  type        = string
}

variable "providers_mapping" {
  description = "List of providers & their details"
  type = list(object({
    name                      = string
    type                      = string
    client_id                 = string
    client_secret             = string
    authorize_scopes          = string
    attributes_request_method = string
    oidc_issuer               = string
    attribute_mapping         = map(string)
  }))
  default = []
}

variable "custom_schemas" {
  description = "custom attributes that can be mapped to by identity providers"
  type = list(object({
    name                = string
    attribute_data_type = string
    required            = bool
    mutable             = bool
  }))
  default = []
}

variable "vpc_config" {
  type = object({
    subnet_ids          = list(string)
    security_groups_ids = list(string)
  })
}