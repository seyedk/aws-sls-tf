locals {

  dynamodb_tables = merge(try(var.serverless.dynamodb_tables, {}), {})


}

