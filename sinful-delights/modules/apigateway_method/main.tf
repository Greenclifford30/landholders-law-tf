resource "aws_api_gateway_method" "method" {
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = var.http_method
  authorization = var.authorizer_id != null ? "CUSTOM" : "NONE"
  authorizer_id = var.authorizer_id
  request_parameters = merge(
    var.expect_uri_parameter ? {
      "method.request.path.${var.uri_param}" = true
    } : {}
  )
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = var.api_id
  resource_id             = var.resource_id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
  request_parameters = merge(
    var.expect_uri_parameter ? {
      "integration.request.path.${var.uri_param}" = "method.request.path.${var.uri_param}"
    } : {}
  )
}

resource "aws_lambda_permission" "invoke" {
  count         = var.lambda_invoke_permission ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke-${var.http_method}-${var.resource_id}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apig_gateway_source_arn}/*/*"
}

###########################################
# Conditional OPTIONS method for CORS
###########################################

resource "aws_api_gateway_method" "options" {
  count         = var.create_options ? 1 : 0
  rest_api_id   = var.api_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  count                   = var.create_options ? 1 : 0
  rest_api_id             = var.api_id
  resource_id             = var.resource_id
  http_method             = "OPTIONS"
  type                    = "MOCK"
  request_templates       = {
    "application/json" = <<EOF
    {
      "statusCode": 200
    }
EOF
  }
}

resource "aws_api_gateway_method_response" "options_response" {
  count       = var.create_options ? 1 : 0
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  count       = var.create_options ? 1 : 0
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = "OPTIONS"
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'",
    "method.response.header.Access-Control-Allow-Methods" = "'*'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
