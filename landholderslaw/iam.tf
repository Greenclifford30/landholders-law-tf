###########################
# IAM Role for the Lambda
###########################
resource "aws_iam_role" "consultation_lambda_role" {
  name               = "consultation-lambda-role"
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
  role       = aws_iam_role.consultation_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

###########################################
# Create and attach an SES send policy
###########################################
resource "aws_iam_policy" "consultation_lambda_ses" {
  name        = "consultation-lambda-ses-policy"
  path        = "/"
  description = "IAM policy for sending emails via SES"

  policy = data.aws_iam_policy_document.ses.json
}

data "aws_iam_policy_document" "ses" {
  statement {
    actions   = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "ses_attach" {
  role       = aws_iam_role.consultation_lambda_role.name
  policy_arn = aws_iam_policy.consultation_lambda_ses.arn
}
