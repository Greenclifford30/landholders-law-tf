#########################################
# 1) Create a REST API in API Gateway
#########################################
resource "aws_api_gateway_rest_api" "sinful_delights_api" {
  name        = "SinfulDelightsAPI"
  description = "Handles Landholders Law API requests"
}


resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_rest_api.sinful_delights_api.root_resource_id
  path_part   = "v1"
}

# Child resources

resource "aws_api_gateway_resource" "menu" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "menu"
}

resource "aws_api_gateway_resource" "menu_today" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.menu.id
  path_part   = "today"
}

resource "aws_api_gateway_resource" "order" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "order"
}

resource "aws_api_gateway_resource" "subscription" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "subscription"
}

resource "aws_api_gateway_resource" "catering" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "catering"
}

# Admin resources
resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "admin"
}

resource "aws_api_gateway_resource" "admin_analytics" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "analytics"
}

resource "aws_api_gateway_resource" "admin_menu" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "menu"
}

resource "aws_api_gateway_resource" "admin_menus" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "menus"
}

resource "aws_api_gateway_resource" "admin_menu_id" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin_menu.id
  path_part   = "{menuId}"
}

resource "aws_api_gateway_resource" "admin_menu_template" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "menu-template"
}

resource "aws_api_gateway_resource" "admin_menu_templates" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "menu-templates"
}

resource "aws_api_gateway_resource" "admin_menu_template_id" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin_menu_template.id
  path_part   = "{templateId}"
}

resource "aws_api_gateway_resource" "admin_menu_import" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "menu"
}

resource "aws_api_gateway_resource" "admin_inventory" {
  rest_api_id = aws_api_gateway_rest_api.sinful_delights_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "inventory"
}

# GET /v1/menu
module "get_menu_today" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.menu.id
  http_method = "GET"
  lambda_arn  = module.get_menu_today_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_menu_today_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/menu/today
module "get_menu_today" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.menu_today.id
  http_method = "GET"
  lambda_arn  = module.get_menu_today_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_menu_today_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# POST /v1/order
module "post_order" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.order.id
  http_method = "POST"
  lambda_arn  = module.post_order_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_order_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/subscription
module "get_subscription" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.subscription.id
  http_method = "GET"
  lambda_arn  = module.get_subscription_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_subscription_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# POST /v1/subscription
module "post_subscription" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.subscription.id
  http_method = "POST"
  lambda_arn  = module.post_subscription_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_subscription_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# POST /v1/catering
module "post_catering" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.catering.id
  http_method = "POST"
  lambda_arn  = module.post_catering_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_catering_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/admin/analytics
module "get_admin_analytics" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_analytics.id
  http_method = "GET"
  lambda_arn  = module.get_admin_analytics_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_admin_analytics_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/admin/menu
module "get_admin_menu" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu.id
  http_method = "GET"
  lambda_arn  = module.post_admin_menu_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_admin_menu_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/admin/menus
module "get_admin_menus" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menus.id
  http_method = "GET"
  lambda_arn  = module.post_admin_menu_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_admin_menu_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/admin/menu/{menuId}
module "get_admin_menu_by_id" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_id.id
  http_method = "GET"
  lambda_arn  = module.get_admin_menu_by_id_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_admin_menu_by_id_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
  expect_uri_parameter = true
  uri_param = "{menuId}"
}

# DELETE /v1/admin/menu/{menuId}
module "delete_admin_menu_by_id" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_id.id
  http_method = "DELETE"
  lambda_arn  = module.delete_admin_menu_by_id_lambda.lambda_function_arn
  lambda_invoke_arn = module.delete_admin_menu_by_id_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
  expect_uri_parameter = true
  uri_param = "{menuId}"
}

# POST /v1/admin/menu
module "post_admin_menu" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu.id
  http_method = "POST"
  lambda_arn  = module.post_admin_menu_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_admin_menu_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/admin/menu-templates
module "get_admin_menu_template" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_templates.id
  http_method = "GET"
  lambda_arn  = module.get_admin_menu_template_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_admin_menu_template_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# POST /v1/admin/menu-template
module "post_admin_menu_template" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_template.id
  http_method = "POST"
  lambda_arn  = module.post_admin_menu_template_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_admin_menu_template_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
}

# GET /v1/admin/menu-templates/{templateId}
module "get_admin_menu_template_by_id" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_template_id.id
  http_method = "PUT"
  lambda_arn  = module.get_admin_menu_template_by_id_lambda.lambda_function_arn
  lambda_invoke_arn = module.get_admin_menu_template_by_id_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
  expect_uri_parameter = true
  uri_param = "{templateId}"
}

# PUT /v1/admin/menu-templates/{templateId}
module "put_admin_menu_template" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_template_id.id
  http_method = "PUT"
  lambda_arn  = module.put_admin_menu_template_lambda.lambda_function_arn
  lambda_invoke_arn = module.put_admin_menu_template_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
  expect_uri_parameter = true
  uri_param = "{templateId}"
}

# DELETE /v1/admin/menu-templates/{templateId}
module "delete_admin_menu_template" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_menu_template_id.id
  http_method = "DELETE"
  lambda_arn  = module.delete_admin_menu_template_lambda.lambda_function_arn
  lambda_invoke_arn = module.delete_admin_menu_template_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
  expect_uri_parameter = true
  uri_param = "{templateId}"
}

# POST /v1/admin/inventory
module "post_admin_inventory" {
  source      = "./modules/apigateway_method"
  api_id      = aws_api_gateway_rest_api.sinful_delights_api.id
  resource_id = aws_api_gateway_resource.admin_inventory.id
  http_method = "POST"
  lambda_arn  = module.post_admin_inventory_lambda.lambda_function_arn
  lambda_invoke_arn = module.post_admin_inventory_lambda.lambda_invoke_arn
  apig_gateway_source_arn = aws_api_gateway_rest_api.sinful_delights_api.execution_arn
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