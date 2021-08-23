serverless = {
  backend_type        = "s3"
  level               = "level2"
  key                 = "serviceb"
  global_settings_key = "foundation"
  key                 = "orders"
  bucket              = "seyedk-tf-accelerator-state-mgmt"

  tfstates = {
    database = {
      level   = "level0"
      tfstate = "db/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true

    }
    app = {
      level   = "level1"
      tfstate = "app/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true
    }
  }
}


