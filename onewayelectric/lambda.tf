resource "aws_lambda_function" "service_request" {
  function_name = "${var.app}-service-request-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip

  # Using a local placeholder zip 
  filename = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  # Example: pass in environment variables
  environment {
    variables = {
      OWNER_EMAIL = var.owner_email
      BUSINESS_EMAIL = var.business_email
      DYNAMODB_TABLE = "${var.app}-service-requests"
    }
  }

  # Optionally set memory, timeout, etc.
  # memory_size = 128
  # timeout     = 10
}

resource "aws_lambda_function" "get_service_requests" {
  function_name = "${var.app}-get-service-requests-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip

  # Using a local placeholder zip 
  filename = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  # Example: pass in environment variables
  environment {
    variables = {
      OWNER_EMAIL = var.owner_email
      BUSINESS_EMAIL = var.business_email
      DYNAMODB_TABLE = "${var.app}-service-requests"
    }
  }

  # Optionally set memory, timeout, etc.
  # memory_size = 128
  # timeout     = 10
}

resource "aws_lambda_function" "patch_service_request" {
  function_name = "${var.app}-patch-service-request-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip

  # Using a local placeholder zip 
  filename = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  # Example: pass in environment variables
  environment {
    variables = {
      DYNAMODB_TABLE = "${var.app}-service-requests"
    }
  }

  # Optionally set memory, timeout, etc.
  # memory_size = 128
  # timeout     = 10
}