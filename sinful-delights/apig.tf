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
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
}

resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sinful_delights_api.id
  stage_name    = "development"
  variables = {
    redeploy_hash = "${timestamp()}"
  }
}

resource "aws_api_gateway_usage_plan" "sinflul_delights_usage_plan" {
  name = "${var.app}-api-usage-plan"

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

resource "aws_api_gateway_api_key" "sinflul_delights_api_key" {
  name        = "${var.app}-api-key"
  description = "API key for sinful delights endpoints"
  enabled     = true
}

resource "aws_api_gateway_usage_plan_key" "sinful_delights_plan_key" {
  key_id        = aws_api_gateway_api_key.sinflul_delights_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.sinflul_delights_usage_plan.id
}