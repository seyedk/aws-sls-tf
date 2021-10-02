serverless = {
  backend_type        = "s3"
  global_settings_key = "foundation"
  key                 = "data"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"

  vpcs         = {}
  api_gateways = {}


  functions = {
    function1 = { # this key will be used for later refrences
      function_name = "my-lambda_1"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "src/function1/index.py"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
      # vpc_info = {

      #   layer_key  = "infra"
      #   vpc_key    = "db_vpc"
      #   subnet_key = "intra_subnets"


      # }
    }




    public_function = {
      function_name = "my-lambda_a"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "src/public_function/index.py"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
      # vpc_info = {

      #   layer_key  = "infra"
      #   vpc_key    = "db_vpc"
      #   subnet_key = "intra_subnets"


      # }
      #vpc_subnet_ids = {
      # service = "infra_svc"
      # vpc_name = "db"
      # subnet_type = "public"
      # }
    }
    private_function = {
      function_name = "my-lambda_b"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "src/private_function/index.py"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
      vpc_info = {

        layer_key  = "infra"
        vpc_key    = "db_vpc"
        subnet_key = "public_subnets"


      }
      vpc_info2 = {
        infra = {
          vpc_key    = "data_vpc"
          subnet_key = "public_subnets"

        }
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
  networking   = {}


  tfstates = {
    infra = {
      tfstate = "infra/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true

    }


  }
}

