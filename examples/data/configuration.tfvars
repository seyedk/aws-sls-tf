serverless = {
  backend_type        = "s3"
  level               = "level0"
  key                 = "data/terraform.tfstate"
  global_settings_key = "foundation"
  key                 = "data"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"




  functions = {
    function1 = {
      function_name = "my-lambda_1"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "../../src/function1.zip"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
    }

    function_A = {
      function_name = "my-lambda_a"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "../../src/functionA.zip"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
    }
    function_B = {
      function_name = "my-lambda_b"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "../../src/functionB.zip"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
    }

  }
  tags = {
    application_name = "data"
    owner            = "seyed"
    environment      = "dev"
  }
  global_settings = {

    env       = "dev"
    workspace = "lab"

  }
  api_gateways = {}
  networking = {}
  tfstates = {}
}