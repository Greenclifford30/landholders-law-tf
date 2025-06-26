resource "aws_lambda_function" "python_lambda" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn
  timeout       = var.timeout
  filename      = var.filename
  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = var.environment_variables
  }

  tags = {
    Project = "SinfulDelights"
  }
}

output "lambda_function_name" {
  value = aws_lambda_function.python_lambda.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.python_lambda.arn
}