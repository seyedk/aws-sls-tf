serverless = {
  backend_type = "s3"

  global_settings_key = "foundation"
  key                 = "experience"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"



  functions = {
    function2 = {
      function_name = "exp-lambda-1"
      description   = "experience 1 lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "../../src/function2.zip"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
    }

    function_B = {
      function_name = "exp-lambda-2"
      description   = "experience 2 lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "../../src/functionB.zip"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
    }
    function_3 = {
      function_name = "exp-lambda-3"
      description   = "experience 3 lambda function"
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
    application_name = "experience service"
    owner            = "seyed"
    environment      = "dev"
  }
  global_settings = {

    env       = "dev"
    workspace = "lab"

  }
  api_gateways = {}
  vpcs   = {}
  tfstates     = {}


}
