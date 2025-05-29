resource "aws_lambda_function" "admin_selection" {
  function_name = "${var.app}-admin-selection"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = {
      MOVIE_SHOWTIME_OPTIONS_TABLE = "${var.app}_movie_showtime_options"
    }
  }
}
resource "aws_lambda_function" "vote_handler" {
  function_name = "${var.app}-vote-handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"


  environment {
    variables = {
      VOTE_TABLE = "UserVotes"
    }
  }
}

resource "aws_lambda_function" "get_selection" {
  function_name = "${var.app}-get-selection"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = {
      ADMIN_SELECTIONS_TABLE = "AdminSelections"
    }
  }
}

resource "aws_lambda_function" "get_options" {
  function_name = "${var.app}-get-options"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"   # We'll define a trivial handler in the placeholder zip
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

}