module "get_menu_today_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-menu-today-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.name
  }
}

module "post_order_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-post-order-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.order.name
  }
}

module "get_subscription_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-subscription-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.subscription.name
  }
}

module "post_subscription_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-post-subscription-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.subscription.name
  }
}

module "post_catering_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-post-catering-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.catering_request.arn
  }
}

module "get_admin_analytics_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-admin-analytics-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
  }
}

module "get_admin_menu_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-admin-menu-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "get_admin_menus_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-admin-menus-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "get_admin_menu_by_id_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-admin-menu-by-id-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "delete_admin_menu_by_id_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-delete-admin-menu-by-id-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "post_admin_menu_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-post-admin-menu-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "post_admin_menu_template_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-post-admin-menu-template-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "get_admin_menu_template_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-admin-menu-template-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "get_admin_menu_template_by_id_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-get-admin-menu-template-by-id-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "put_admin_menu_template_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-put-admin-menu-template-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "delete_admin_menu_template_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-delete-admin-menu-template-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu.arn
  }
}

module "post_admin_inventory_lambda" {
  source            = "./modules/python_module"
  function_name     = "${var.app}-post-admin-inventory-lambda"
  role_arn          = aws_iam_role.sinflul_delights_lambda_role.arn
  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.menu_item.name
  }
}
