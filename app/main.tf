terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = ">= 2.0"
}

terraform {
  backend "s3" {
    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

    bucket         = "seyedk-tf-accelerator-state-mgmt"
    key            = "app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
    encrypt        = true
  }
}


resource "aws_ssm_parameter" "canaries" {
  name  = "/canaries/ServiceFirst/Active"
  type  = "String"
  value = "Yes"
}
resource "aws_ssm_parameter" "sns_topic" {
  name = "/canaries/ServiceFirst/SNSTopic"
  type = "String" 
  value = var.service_first_topic_name
}

resource "aws_cloudwatch_log_group" "canaries" {
  name = "/aws/events/aws_cnary_event_bus"

  tags = {
    Name = "aws_cnary_event_bus-log-group"
  }
}

resource "aws_cloudwatch_event_rule" "canary" {

  name = "capture-ssm-parameter-featureflag"
  description = "captures changes to the Canary feature flag (Yet/No)"

  event_pattern = jsonencode({ "source" : ["aws.ssm"] , "detail-type": ["Parameter Store Change"],"detail": {"name": ["/canaries/ServiceFirst/Active"],
        "operation": [
            "Update"
            ]
    } })
  
}

resource "aws_cloudwatch_event_target" "canary" {
  rule = aws_cloudwatch_event_rule.canary.name
  target_id = "SentToLambda"
  arn = module.lambda_function.lambda_function_arn
}

# resource "aws_iam_role_policy_attachment" "fflag_lambda" {
#   role       = aws_iam_role.fflag_lambda.name
#   policy_arn = aws_iam_policy.fflag_lambda.arn
# }

# resource "aws_iam_role" "fflag_lambda" {

#   name = "iam_for_fflag_lambda"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

module "lambda_function" {
  # Documentaiton: https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest

  source = "terraform-aws-modules/lambda/aws"

  function_name = "feature-flag-handler"
  description   = "Canary feature flag handler"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true
  create_package = false

  # source_path = "src/lambda-function1.py"
  local_existing_package = "archive.zip"

   environment_variables = {
    FFLAG_NAME = aws_ssm_parameter.canaries.name
    SNS_TOPIC_ARN = aws_ssm_parameter.sns_topic.name
    # LAMBDA_ARN = var.lambda_subscriber_arn
  }

  allowed_triggers = {
    featureFlagRule = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.canary.arn
    }
  }

  tags = {
    Name = "feature-flag-handler"
  }
}


variable "service_first_topic_name" {} 


## Todo: removing this line to a better checked data structure
# output "objects" {

#   value = module.lambda_function
  
# }

## todo: using the following to remote the emtpy / null values of the map:

output "objects" {
  value = tomap(
    {
      (var.accelerator.key) = {
        for key, value in module.serverless: key => value
        if try(value , {}) != {}
      }
    }
  )
  
}
