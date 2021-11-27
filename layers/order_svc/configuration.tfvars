serverless = {
  backend_type        = "s3"
  global_settings_key = "application"
  key                 = "orders_service"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"





  api_gateways = {
    api1 = {
      name          = "dev-http"
      description   = "My awesome HTTP API Gateway"
      protocol_type = "HTTP"
      cors_configuration = {
        allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
        allow_methods = ["*"]
        allow_origins = ["*"]
      }

      # # Custom domain
      domain_name                 = "api.example.com"
      domain_name_certificate_arn = "arn:aws:acm:us-east-1:539790979880:certificate/386acf1c-ac20-4348-b0eb-a7615c2e89e9"

      # Access logs
      default_stage_access_log_destination_arn = "arn:aws:logs:us-east-1:539790979880:log-group:debug-apigateway"
      default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"



      tags = {
        Name = "http-apigateway"
      }



      integrations = {

        "POST /" = {
          layer_key           = "data"
          function_key          = "function1"
          payload_format_version = "2.0"
          timeout_milliseconds   = 12000
        }
        "GET /" = {
          layer_key           = "experience"
          function_key          = "function_B"
          payload_format_version = "2.0"
          timeout_milliseconds   = 12000

        }
        "POST /services" = {
          layer_key           = "data"
          function_key          = "public_function"
          payload_format_version = "2.0"
          timeout_milliseconds   = 12000
        }
      }


    }
    api2 = {
      name          = "qa-http"
      description   = "My second HTTP API Gateway"
      protocol_type = "HTTP"
      cors_configuration = {
        allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
        allow_methods = ["*"]
        allow_origins = ["*"]
      }

      # Custom domain
      domain_name                 = "api.example.com"
      domain_name_certificate_arn = "arn:aws:acm:us-east-1:539790979880:certificate/386acf1c-ac20-4348-b0eb-a7615c2e89e9"

      # Access logs
      default_stage_access_log_destination_arn = "arn:aws:logs:us-east-1:539790979880:log-group:debug-apigateway"
      default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"



      tags = {
        Name        = "http-apigateway"
        environment = "QA"
      }

      integrations = {

        "POST /users" = {
          layer_key           = "experience"
          function_key          = "function_3"
          payload_format_version = "2.0"
          timeout_milliseconds   = 12000
        }
        "GET /users" = {
          layer_key           = "experience"
          function_key          = "function_3"
          payload_format_version = "2.0"
          timeout_milliseconds   = 12000

        }
      }


    }
  }

  global_settings = {

    env       = "dev"
    workspace = "lab"

  }

  functions = {}
  vpcs = {}

  tags = {
    application_name = "experience service"
    owner            = "seyed"
    environment      = "dev"
  }

  tfstates = {
    data = {
      tfstate = "data/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true

    }
    experience = {
      tfstate = "experience/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true
    }

  }

}
