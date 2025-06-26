module "create_menu_lambda" {
  source     = "./modules/python_lambda"
  function_name = "${var.app_underscore}_create_menu"
  role_arn      = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.sinful_delights.name
  }
}
