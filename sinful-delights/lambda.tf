module "create_menu_lambda" {
  source     = "./modules/python_module"
  function_name = "${var.app}-create-menu-lambda"
  role_arn      = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.sinful_delights.name
  }
}
