#########################################
# 1) Create a REST API in API Gateway
#########################################
resource "aws_api_gateway_rest_api" "stricklin_api" {
  name        = "StricklinAPI"
  description = ""
}

#########################################
# 2) Create the "/admin" Resource
#########################################
resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
  parent_id   = aws_api_gateway_rest_api.stricklin_api.root_resource_id
  path_part   = "admin"
}

#########################################
# 2) Create the "/admin/menu" Resource
#########################################
resource "aws_api_gateway_resource" "checkin" {
  rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "checkin"
}

resource "aws_api_gateway_resource" "attendee_id" {
  rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
  parent_id   = aws_api_gateway_resource.checkin.id
  path_part   = "{attendeeId}"
}

module "checkin_post" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.stricklin_api.id
  resource_id = aws_api_gateway_resource.attendee_id.id
  http_method = "POST"
  lambda_arn  = module.post_checkin_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_checkin_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.stricklin_api.execution_arn
}

resource "aws_api_gateway_resource" "dashboard" {
  rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "dashboard"
}


module "get_dashboard" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.stricklin_api.id
  resource_id = aws_api_gateway_resource.dashboard.id
  http_method = "GET"
  lambda_arn  = module.get_dashboard_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_dashboard_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.stricklin_api.execution_arn
}


resource "aws_api_gateway_resource" "attendees" {
    rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "attendees"
}

module "get_attendees" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.stricklin_api.id
  resource_id = aws_api_gateway_resource.attendees.id
  http_method = "GET"
  lambda_arn  = module.get_attendees_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_attendees_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.stricklin_api.execution_arn
}

resource "aws_api_gateway_resource" "search_attendees" {
  rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
  parent_id   = aws_api_gateway_resource.attendees.id
  path_part   = "search"
}

module "get_search_attendees" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.stricklin_api.id
  resource_id = aws_api_gateway_resource.search_attendees.id
  http_method = "GET"
  lambda_arn  = module.get_search_attendees_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_search_attendees_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.stricklin_api.execution_arn
}
#########################################
# 6) Create a Deployment and a Stage
#########################################
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.stricklin_api.id
}

resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.stricklin_api.id
  stage_name    = "development"
  variables = {
    redeploy_hash = "${timestamp()}"
  }
}

resource "aws_api_gateway_usage_plan" "stricklin_usage_plan" {
  name = "stricklin-api-usage-plan"

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
    api_id = aws_api_gateway_rest_api.stricklin_api.id
    stage  = "development"
  }
}

resource "aws_api_gateway_api_key" "stricklin_api_key" {
  name        = "${var.app}-api-key"
  description = "API key for sinful delights endpoints"
  enabled     = true
}

resource "aws_api_gateway_usage_plan_key" "stricklin_plan_key" {
  key_id        = aws_api_gateway_api_key.stricklin_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.stricklin_usage_plan.id
}