#########################################
# 1) Create a REST API in API Gateway
#########################################
resource "aws_api_gateway_rest_api" "landholderslaw_api" {
  name        = "LandholdersLawAPI"
  description = "Handles Landholders Law API requests"
}

#########################################
# 2) Create the "/consultation" Resource
#########################################
resource "aws_api_gateway_resource" "consultation_resource" {
  rest_api_id = aws_api_gateway_rest_api.landholderslaw_api.id
  parent_id   = aws_api_gateway_rest_api.landholderslaw_api.root_resource_id
  path_part   = "consultation"
}

#########################################
# 3) Configure the POST Method
#########################################
resource "aws_api_gateway_method" "consultation_post" {
  rest_api_id   = aws_api_gateway_rest_api.landholderslaw_api.id
  resource_id   = aws_api_gateway_resource.consultation_resource.id
  http_method   = "POST"
  authorization = "NONE"
  # If you'd like to secure this method using IAM, Cognito, or an API key,
  # you can change 'NONE' to the appropriate authorization type.
}

#########################################
# 4) Create the Lambda Integration (AWS_PROXY)
#########################################
resource "aws_api_gateway_integration" "consultation_integration" {
  rest_api_id             = aws_api_gateway_rest_api.landholderslaw_api.id
  resource_id             = aws_api_gateway_resource.consultation_resource.id
  http_method             = aws_api_gateway_method.consultation_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.consultation_lambda.invoke_arn
}

###############################################################
# 5) Allow API Gateway to invoke the Lambda (Lambda Permission)
###############################################################
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consultation_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # This grants permission for any resource/method under this API stage
  source_arn = "${aws_api_gateway_rest_api.landholderslaw_api.execution_arn}/*/*"
}

#########################################
# 6) Create a Deployment and a Stage
#########################################
resource "aws_api_gateway_deployment" "consultation_deployment" {
  depends_on = [
    aws_api_gateway_integration.consultation_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.landholderslaw_api.id
}

resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.consultation_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.landholderslaw_api.id
  stage_name    = "development"
}

##############################
# OPTIONS Method on /consultation
##############################
resource "aws_api_gateway_method" "consultation_options" {
  rest_api_id = aws_api_gateway_rest_api.landholderslaw_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "consultation_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.landholderslaw_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = aws_api_gateway_method.consultation_options.http_method
  type = "MOCK"

  # A mock integration returns a static response (statusCode=200)
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

resource "aws_api_gateway_method_response" "consultation_options_200" {
  rest_api_id = aws_api_gateway_rest_api.landholderslaw_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = aws_api_gateway_method.consultation_options.http_method
  status_code = 200

  # Each key must be set to 'true' to pass through the header
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "consultation_options_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.landholderslaw_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = aws_api_gateway_method.consultation_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
