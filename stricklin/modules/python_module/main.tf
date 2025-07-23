# Generate a temporary zip file with a simple Python handler
data "archive_file" "lambda_stub" {
  type        = "zip"
  output_path = "${path.module}/bootstrap/lambda_stub.zip"

  source {
    content  = <<EOF
        def lambda_handler(event, context):
            return {
                'statusCode': 200,
                'body': 'Stub Lambda'
            }
        EOF
    filename = "app.py"
  }
}

resource "aws_lambda_function" "python_lambda" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn
  timeout       = var.timeout

  filename         = data.archive_file.lambda_stub.output_path
  source_code_hash = data.archive_file.lambda_stub.output_base64sha256

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

output "lambda_invoke_arn" {
  value = aws_lambda_function.python_lambda.invoke_arn
}