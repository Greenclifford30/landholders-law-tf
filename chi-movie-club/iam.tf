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
  description = "IAM policy for Chi Movie Club lambdas"

  policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = ["*"]

  }
  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:TransactWriteItems",
      "dynamodb:BatchWriteItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]
    resources = [
      aws_dynamodb_table.app.arn,
      "${aws_dynamodb_table.app.arn}/index/GSI1",
      "${aws_dynamodb_table.app.arn}/index/GSI2",
    ]

  }
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [
      aws_sqs_queue.admin_selection.arn,
      aws_sqs_queue.gracenote_showtime_refresh_queue.arn,
    ]

  }
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role" "movie_search_lambda_role" {
  name               = "${var.app}-movie-search-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "movie_search_basic_execution" {
  role       = aws_iam_role.movie_search_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "movie_search_lambda_policy" {
  name        = "${var.app}-movie-search-policy"
  path        = "/"
  description = "IAM policy for Movie Club movie search Lambda."

  policy = data.aws_iam_policy_document.movie_search_lambda_policy.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "movie_search_lambda_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [aws_secretsmanager_secret.tmdb_api_token.arn]
  }
}

resource "aws_iam_role_policy_attachment" "movie_search_attach" {
  role       = aws_iam_role.movie_search_lambda_role.name
  policy_arn = aws_iam_policy.movie_search_lambda_policy.arn
}

resource "aws_iam_role" "gracenote_showtime_coordinator_lambda_role" {
  name               = "${var.app}-gracenote-showtime-coordinator-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "gracenote_showtime_coordinator_basic_execution" {
  role       = aws_iam_role.gracenote_showtime_coordinator_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "gracenote_showtime_coordinator_policy" {
  name        = "${var.app}-gracenote-showtime-coordinator-policy"
  path        = "/"
  description = "IAM policy for the Gracenote showtime coordinator Lambda."

  policy = data.aws_iam_policy_document.gracenote_showtime_coordinator_policy.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "gracenote_showtime_coordinator_policy" {
  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [aws_sqs_queue.gracenote_showtime_refresh_queue.arn]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Query",
    ]
    resources = [
      aws_dynamodb_table.app.arn,
      "${aws_dynamodb_table.app.arn}/index/GSI1",
      "${aws_dynamodb_table.app.arn}/index/GSI2",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "gracenote_showtime_coordinator_attach" {
  role       = aws_iam_role.gracenote_showtime_coordinator_lambda_role.name
  policy_arn = aws_iam_policy.gracenote_showtime_coordinator_policy.arn
}

resource "aws_iam_role" "gracenote_showtime_worker_lambda_role" {
  name               = "${var.app}-gracenote-showtime-worker-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "gracenote_showtime_worker_basic_execution" {
  role       = aws_iam_role.gracenote_showtime_worker_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "gracenote_showtime_worker_policy" {
  name        = "${var.app}-gracenote-showtime-worker-policy"
  path        = "/"
  description = "IAM policy for the Gracenote showtime worker Lambda."

  policy = data.aws_iam_policy_document.gracenote_showtime_worker_policy.json

  tags = local.common_tags
}

data "aws_iam_policy_document" "gracenote_showtime_worker_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [aws_secretsmanager_secret.gracenote_api_key.arn]
  }

  statement {
    actions = [
      "dynamodb:PutItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
    ]
    resources = [
      aws_dynamodb_table.app.arn,
      "${aws_dynamodb_table.app.arn}/index/GSI1",
      "${aws_dynamodb_table.app.arn}/index/GSI2",
    ]
  }

  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:ChangeMessageVisibility",
    ]
    resources = [aws_sqs_queue.gracenote_showtime_refresh_queue.arn]
  }
}

resource "aws_iam_role_policy_attachment" "gracenote_showtime_worker_attach" {
  role       = aws_iam_role.gracenote_showtime_worker_lambda_role.name
  policy_arn = aws_iam_policy.gracenote_showtime_worker_policy.arn
}
