serverless = {
  backend_type        = "s3"
  level               = "level2"
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

      # Custom domain
      domain_name                 = "api.pacificbluepine.com"
      domain_name_certificate_arn = "arn:aws:acm:us-east-1:539790979880:certificate/386acf1c-ac20-4348-b0eb-a7615c2e89e9"

      # Access logs
      default_stage_access_log_destination_arn = "arn:aws:logs:us-east-1:539790979880:log-group:debug-apigateway"
      default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"



      tags = {
        Name = "http-apigateway"
      }



    }
  }

  global_settings = {

    env       = "dev"
    workspace = "lab"

  }

  functions  = {}
  networking = {}
  tags = {
    application_name = "experience service"
    owner            = "seyed"
    environment      = "dev"
  }

  tfstates = {
    data = {
      level   = "level0"
      tfstate = "data/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true

    }
    experience = {
      level   = "level1"
      tfstate = "experience/terraform.tfstate"

      region         = "us-east-1"
      dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
      encrypt        = true
    }
  }
}

