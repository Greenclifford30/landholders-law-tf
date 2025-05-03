resource "aws_lambda_function" "consultation_lambda" {
  function_name = "consultation-lambda"
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
    }
  }

  # Optionally set memory, timeout, etc.
  # memory_size = 128
  # timeout     = 10
}
