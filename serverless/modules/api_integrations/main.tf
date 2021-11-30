
resource "aws_apigatewayv2_route" "this" {
  for_each = var.create && var.create_routes_and_integrations ? var.api_integrations : {}

  route_key = each.key
  api_id    = each.value.api_id

  # api_key_required                    = lookup(each.value, "api_key_required", null)
  authorization_type                  = lookup(each.value, "authorization_type", "NONE")
  authorizer_id                       = lookup(each.value, "authorizer_id", null)
  # model_selection_expression          = lookup(each.value, "model_selection_expression", null)
  operation_name                      = lookup(each.value, "operation_name", null)
  route_response_selection_expression = lookup(each.value, "route_response_selection_expression", null)
  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"

  # Not sure what structure is allowed for these arguments...
  #  authorization_scopes = lookup(each.value, "authorization_scopes", null)
  #  request_models  = lookup(each.value, "request_models", null)
}

resource "aws_apigatewayv2_integration" "this" {
  for_each =  var.api_integrations

  api_id      = lookup(each.value, "api_id",null)
  description = lookup(each.value, "description", null)

  integration_type    = lookup(each.value, "integration_type", lookup(each.value, "lambda_arn", "") != "" ? "AWS_PROXY" : "MOCK")
  integration_subtype = lookup(each.value, "integration_subtype", null)
  integration_method  = lookup(each.value, "integration_method", lookup(each.value, "integration_subtype", null) == null ? "POST" : null)
  integration_uri     = lookup(each.value, "lambda_arn", lookup(each.value, "integration_uri", null))

  # connection_type = lookup(each.value, "connection_type", "INTERNET")
  # connection_id   = try(aws_apigatewayv2_vpc_link.this[each.value["vpc_link"]].id, lookup(each.value, "connection_id", null))

  payload_format_version    = lookup(each.value, "payload_format_version", null)
  timeout_milliseconds      = lookup(each.value, "timeout_milliseconds", null)
  passthrough_behavior      = lookup(each.value, "passthrough_behavior", null)
  content_handling_strategy = lookup(each.value, "content_handling_strategy", null)
  credentials_arn           = lookup(each.value, "credentials_arn", null)
  request_parameters        = try(jsondecode(each.value["request_parameters"]), each.value["request_parameters"], null)

  dynamic "tls_config" {
    for_each = flatten([try(jsondecode(each.value["tls_config"]), each.value["tls_config"], [])])
    content {
      server_name_to_verify = tls_config.value["server_name_to_verify"]
    }
  }

  dynamic "response_parameters" {
    for_each = flatten([try(jsondecode(each.value["response_parameters"]), each.value["response_parameters"], [])])
    content {
      status_code = response_parameters.value["status_code"]
      mappings    = response_parameters.value["mappings"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# VPC Link (Private API)

