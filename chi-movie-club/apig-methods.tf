# POST /admin/selection
resource "aws_api_gateway_method" "post_admin_selection" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.selection.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "post_admin_selection_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.selection.id
  http_method             = aws_api_gateway_method.post_admin_selection.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.admin_selection.invoke_arn
}

# POST /vote
resource "aws_api_gateway_method" "post_vote" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.vote.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "post_vote_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.vote.id
  http_method             = aws_api_gateway_method.post_vote.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.vote_handler.invoke_arn
}

# GET /selection
resource "aws_api_gateway_resource" "selection_get" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "selection"
}

resource "aws_api_gateway_method" "get_selection" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.selection_get.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "get_selection_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.selection_get.id
  http_method             = aws_api_gateway_method.get_selection.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_selection.invoke_arn
}

# GET /options
resource "aws_api_gateway_method" "get_options" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.options.id
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "get_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.options.id
  http_method             = aws_api_gateway_method.get_options.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_options.invoke_arn
}


resource "aws_lambda_permission" "allow_apig" {
  for_each = {
    admin_selection = aws_lambda_function.admin_selection
    vote_handler    = aws_lambda_function.vote_handler
    get_selection   = aws_lambda_function.get_selection
    get_options     = aws_lambda_function.get_options
  }

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chimovieclub_api.execution_arn}/*/*"
}
