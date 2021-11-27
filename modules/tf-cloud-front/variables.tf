variable "dns_zone_name" {
  type = string //dev.mydomain.io
}

variable "tags" {
  type = map(string)
}

variable "deployment_label" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "lambda_edge_trigger" {
  type = string
}

variable "lambda_edge_arn" {
  type = string
}

variable "use_imported_cert" {
  description = "ARN for issued cert"
  type = bool
  default = false
}
