serverless = {
  backend_type        = "s3"
  global_settings_key = "foundation"
  key                 = "data"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"


  cognito_userpools = {
    swimming_pool = {
      user_pool_name = "swimming_pool"
      tags = {
        Owner       = "infra"
        Environment = "production"
        Terraform   = true
      }
    }
    eithball_pool = {
      user_pool_name = "8ball_pool"
      tags = {
        Owner       = "infra"
        Environment = "production"
        Terraform   = true
      }
    }
    user_pool_three = {
      user_pool_name                                     = "simple_extended_pool"
      alias_attributes                                   = ["email", "phone_number"]
      auto_verified_attributes                           = ["email"]
      sms_authentication_message                         = "Your username is {username} and temporary password is {####}."
      sms_verification_message                           = "This is the verification message {####}."
      lambda_config_verify_auth_challenge_response       = "arn:aws:lambda:us-east-1:123456789012:function:my_lambda_function"
      password_policy_require_lowercase                  = false
      password_policy_minimum_length                     = 11
      user_pool_add_ons_advanced_security_mode           = "OFF"
      verification_message_template_default_email_option = "CONFIRM_WITH_CODE"

      # schemas
      schemas = [
        {
          attribute_data_type      = "Boolean"
          developer_only_attribute = false
          mutable                  = true
          name                     = "available"
          required                 = false
        },
      ]

      string_schemas = [
        {
          attribute_data_type      = "String"
          developer_only_attribute = false
          mutable                  = false
          name                     = "email"
          required                 = true

          string_attribute_constraints = {
            min_length = 7
            max_length = 15
          }
        },
      ]

      # user_pool_domain
      domain = "mydomain-com"

      # client
      client_name                                 = "client0"
      client_allowed_oauth_flows_user_pool_client = false
      client_callback_urls                        = ["https://mydomain.com/callback"]
      client_default_redirect_uri                 = "https://mydomain.com/callback"
      client_read_attributes                      = ["email"]
      client_refresh_token_validity               = 30


      # user_group
      user_group_name        = "mygroup"
      user_group_description = "My group"

      # ressource server
      resource_server_identifier        = "https://mydomain.com"
      resource_server_name              = "mydomain"
      resource_server_scope_name        = "scope"
      resource_server_scope_description = "a Sample Scope Description for mydomain"

      # tags
      tags = {
        Owner       = "infra"
        Environment = "production"
        Terraform   = true
      }
    }
  }

  vpcs = {

    lambda_vpc = {

      cidr            = "192.168.0.0/16"
      azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
      private_subnets = ["192.168.101.0/24", "192.168.102.0/24", "192.168.103.0/24"]
      # Add public_subnets and NAT Gateway to allow access to internet from Lambda
      public_subnets     = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
      enable_nat_gateway = true



    }
  }
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
      vpc_info = {

        layer_key  = "data"
        vpc_key    = "lambda_vpc"
        subnet_key = "public_subnets"
      }
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


