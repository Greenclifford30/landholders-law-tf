#########################################
# 1) Create a REST API in API Gateway
#########################################
resource "aws_api_gateway_rest_api" "chimovieclub_api" {
  name        = "${var.app}-api"
  description = "Handles One Way Chi Movie Club API requests"
}

resource "aws_api_gateway_deployment" "cmc_deployment" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
}

resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.cmc_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  stage_name    = "development"
  variables = {
    redeploy_hash = "${timestamp()}"
  }
}

resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "admin"
}

resource "aws_api_gateway_resource" "selection" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "selection"
}

resource "aws_api_gateway_resource" "vote" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "vote"
}

resource "aws_api_gateway_resource" "options" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "options"
}

resource "aws_api_gateway_usage_plan" "chimovieclub_usage_plan" {
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
    api_id = aws_api_gateway_rest_api.chimovieclub_api.id
    stage  = "development"
  }
}

resource "aws_api_gateway_api_key" "chimovieclub_api_key" {
  name        = "${var.app}-api-key"
  description = "API key for one way electric endpoints"
  enabled     = true
}

resource "aws_api_gateway_usage_plan_key" "chimovieclub_law_api_key" {
  key_id        = aws_api_gateway_api_key.chimovieclub_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.chimovieclub_usage_plan.id
}


resource "aws_api_gateway_method" "selection_options" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "selection_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = aws_api_gateway_method.selection_options.http_method
  type = "MOCK"

  # A mock integration returns a static response (statusCode=200)
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

resource "aws_api_gateway_method_response" "selection_options_200" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = aws_api_gateway_method.selection_options.http_method
  status_code = 200

  # Each key must be set to 'true' to pass through the header
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "selection_options_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = aws_api_gateway_method.selection_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}