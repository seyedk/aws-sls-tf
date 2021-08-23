serverless = {
  backend_type        = "s3"
  level               = "level2"
  global_settings_key = "application"
  key                 = "orders_service"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"

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
      domain_name                 = "terraform-aws-modules.modules.tf"
      domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

      # Access logs
      default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
      default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

      #     # Routes and integrations
      #     integrations = {
      #       "POST /" = {
      #         lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
      #         payload_format_version = "2.0"
      #         timeout_milliseconds   = 12000
      #       }

      #       "$default" = {
      #         lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
      #       }
      #     }
    }

    tags = {
      Name = "http-apigateway"
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
  #   }

  #   api2 = {
  #     name          = "dev-http2"
  #     description   = "My awesome HTTP API Gateway2"
  #     protocol_type = "HTTP"

  #     cors_configuration = {
  #       allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
  #       allow_methods = ["*"]
  #       allow_origins = ["*"]
  #     }

  #     # Custom domain
  #     domain_name                 = "terraform-aws-modules.modules.tf"
  #     domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

  #     # Access logs
  #     default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
  #     default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  #     # Routes and integrations
  #     integrations = {
  #       "POST /" = {
  #         lambda_arn             = "function1"
  #         payload_format_version = "2.0"
  #         timeout_milliseconds   = 12000
  #       }

  #       "$default" = {
  #         lambda_arn = "default_function"
  #       }
  #     }

  #     tags = {
  #       Name        = "http-apigateway"
  #       develop     = "seyedk"
  #       environment = "qa"
  #     }

  #   }
  # }

  # api_lambda_integrations = {
  #   api1 = {
  #     name = "myApi1"
  #     resource1 = {
  #       path                 = "/"
  #       action               = "POST"
  #       function_key         = "funcion1"
  #       timeout_milliseconds = 12000
  #     }
  #     resource2 = {
  #       path                 = "/"
  #       action               = "POST"
  #       function_key         = "funcion2"
  #       timeout_milliseconds = 12000
  #     }


  #   }
  #     api2 = {
  #     name = "myApi2"
  #     resource1 = {
  #       path                 = "/"
  #       action               = "POST"
  #       function_key         = "funciona"
  #       timeout_milliseconds = 12000
  #     }
  #     resource2 = {
  #       path                 = "/"
  #       action               = "POST"
  #       function_key         = "funcionb"
  #       timeout_milliseconds = 12000
  #     }


  #   }


  # }

}

