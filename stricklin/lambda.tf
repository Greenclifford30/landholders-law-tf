module "get_dashboard_lambda" {
  source     = "./modules/python_module"
  function_name = "${var.app}-get-dashboard-lambda"
  role_arn      = aws_iam_role.stricklin_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.attendees.name
  }
}

module "post_checkin_lambda" {
  source     = "./modules/python_module"
  function_name = "${var.app}-post-checkin-lambda"
  role_arn      = aws_iam_role.stricklin_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.attendees.name
  }
}