# lambda_functions = {
#   function1 = {
#     function_name = "my-lambda1"
#     description   = "my awesome lambda function"
#     handler       = "index.lambda_handler"
#     runtime       = "python3.8"
#     source_path   = "src/archive.zip"
#     tags = {
#       environment = "dev"
#       developer   = "seyedk"

#     }
#   }

#   functiona = {
#     function_name = "my-lambdaa"
#     description   = "my awesome lambda function"
#     handler       = "index.lambda_handler"
#     runtime       = "python3.8"
#     source_path   = "src/archive.zip"
#     tags = {
#       environment = "dev"
#       developer   = "seyedk"

#     }
#   }
#     functionb = {
#     function_name = "my-lambdab"
#     description   = "my awesome lambda function"
#     handler       = "index.lambda_handler"
#     runtime       = "python3.8"
#     source_path   = "src/archive.zip"
#     tags = {
#       environment = "dev"
#       developer   = "seyedk"

#     }
#   }
# }

# api_gateways = {
#   api1 = {
#     name          = "dev-http"
#     description   = "My awesome HTTP API Gateway"
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
#         lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
#         payload_format_version = "2.0"
#         timeout_milliseconds   = 12000
#       }

#       "$default" = {
#         lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
#       }
#     }

#     tags = {
#       Name = "http-apigateway"
#     }

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

