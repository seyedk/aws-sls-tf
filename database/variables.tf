variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  default     = "seyedk-tf-accelerator-state-mgmt"
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this AWS account."
  type        = string
  default = "seyedk-tf-accelerator-state-mgmt"
}


variable "db_password" {
  description = "The password for the database"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_prod"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}
