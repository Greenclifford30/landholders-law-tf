#########################################
# 1) Create a REST API in API Gateway
#########################################
resource "aws_api_gateway_rest_api" "sinful_delights_api" {
  name        = "SinfulDelightsAPI"
  description = "Handles Landholders Law API requests"
}

#########################################
# 2) Create the "/admin" Resource
#########################################
resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_rest_api.sinful_delights_api.root_resource_id
  path_part   = "admin"
}

#########################################
# 2) Create the "/admin/menu" Resource
#########################################
resource "aws_api_gateway_resource" "admin_menu" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "menu"
}

module "create_menu_post" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu.id
  http_method = "POST"
  lambda_arn  = module.create_menu_lambda.lambda_function_arn
}

#########################################
# 6) Create a Deployment and a Stage
#########################################
resource "aws_api_gateway_deployment" "consultation_deployment" {
  depends_on = [
    aws_api_gateway_integration.consultation_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
}

resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.consultation_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sinful_delights_api.id
  stage_name    = "development"
  variables = {
    redeploy_hash = "${timestamp()}"
  }
}

##############################
# OPTIONS Method on /consultation
##############################
resource "aws_api_gateway_method" "consultation_options" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "consultation_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = aws_api_gateway_method.consultation_options.http_method
  type = "MOCK"

  # A mock integration returns a static response (statusCode=200)
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

resource "aws_api_gateway_method_response" "consultation_options_200" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
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
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.consultation_resource.id
  http_method = aws_api_gateway_method.consultation_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

resource "aws_api_gateway_usage_plan" "consultation_usage_plan" {
  name = "landholders-law-api-usage-plan"

  # (Optional) Throttling settings
  throttle_settings {
    burst_limit = 100   # Max requests in a single burst
    rate_limit  = 50    # Steady-state requests per second
  }

  # (Optional) Quota settings
  quota_settings {
    limit  = 10000      # Max requests per month
    period = "MONTH"
  }

  # Associate this plan with your REST API’s stage
  api_stages {
    api_id = aws_api_gateway_rest_api.sinful_delights_api.id
    stage  = "development"
  }
}

resource "aws_api_gateway_api_key" "landholders_law_api_key" {
  name        = "landholders-law-api-key"
  description = "API key for landholders law endpoints"
  enabled     = true
}

resource "aws_api_gateway_usage_plan_key" "consultation_plan_key" {
  key_id        = aws_api_gateway_api_key.landholders_law_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.consultation_usage_plan.id
}