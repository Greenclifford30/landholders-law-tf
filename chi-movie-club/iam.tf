###########################
# IAM Role for the Lambda
###########################
resource "aws_iam_role" "lambda_role" {
  name               = "${var.app}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

####################################
# Attach the basic Lambda execution
# policy (for CloudWatch Logs, etc.)
####################################
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

###########################################
# Create and attach an SES send policy
###########################################
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.app}-lambda-policy"
  path        = "/"
  description = "IAM policy for OWE lambdas"

  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions   = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = ["*"]
    
  }
    statement {
    actions   = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
    ]
    resources = [aws_dynamodb_table.admin_selections.arn, aws_dynamodb_table.user_votes.arn]
    
  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
