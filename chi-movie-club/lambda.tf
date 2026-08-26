locals {
  app_lambda_handlers = {
    movie_search = {
      function_name = "${var.app}-movie-search-lambda"
    }
    create_movie_night = {
      function_name = "${var.app}-create-movie-night-lambda"
    }
    get_active_movie_night = {
      function_name = "${var.app}-get-active-movie-night-lambda"
    }
    manage_showtimes = {
      function_name = "${var.app}-manage-showtimes-lambda"
    }
    submit_vote = {
      function_name = "${var.app}-submit-vote-lambda"
    }
    vote_results = {
      function_name = "${var.app}-vote-results-lambda"
    }
    confirm_showtime = {
      function_name = "${var.app}-confirm-showtime-lambda"
    }
    complete_movie_night = {
      function_name = "${var.app}-complete-movie-night-lambda"
    }
    update_rsvp = {
      function_name = "${var.app}-update-rsvp-lambda"
    }
    list_history = {
      function_name = "${var.app}-list-history-lambda"
    }
    manage_clubs = {
      function_name = "${var.app}-manage-clubs-lambda"
    }
    manage_invites = {
      function_name = "${var.app}-manage-invites-lambda"
    }
    manage_preferences = {
      function_name = "${var.app}-manage-preferences-lambda"
    }
    get_attendance = {
      function_name = "${var.app}-get-attendance-lambda"
    }
    get_calendar = {
      function_name = "${var.app}-get-calendar-lambda"
    }
  }

  lambda_log_group_names = merge(
    {
      admin_selection                = "/aws/lambda/${var.app}-admin-selection-lambda"
      movie_scraper                  = "/aws/lambda/${var.app}-movie-scraper-lambda"
      gracenote_showtime_coordinator = "/aws/lambda/${var.app}-gracenote-showtime-coordinator-lambda"
      gracenote_showtime_worker      = "/aws/lambda/${var.app}-gracenote-showtime-worker-lambda"
      vote_handler                   = "/aws/lambda/${var.app}-vote-handler"
      get_selection                  = "/aws/lambda/${var.app}-get-selection-lambda"
      get_options                    = "/aws/lambda/${var.app}-get-options-lambda"
    },
    {
      for name, handler in local.app_lambda_handlers :
      name => "/aws/lambda/${handler.function_name}"
    }
  )
}

resource "aws_cloudwatch_log_group" "lambda" {
  for_each = local.lambda_log_group_names

  name              = each.value
  retention_in_days = var.lambda_log_retention_days

  tags = local.common_tags
}

resource "aws_lambda_function" "admin_selection" {
  function_name = "${var.app}-admin-selection-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = {
      ADMIN_SELECTION_QUEUE_URL = aws_sqs_queue.admin_selection.id
      APP_TABLE_NAME            = aws_dynamodb_table.app.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "movie_scraper" {
  function_name = "${var.app}-movie-scraper-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"
  timeout       = 60

  environment {
    variables = {
      APP_TABLE_NAME               = aws_dynamodb_table.app.name
      MOVIE_SHOWTIME_OPTIONS_TABLE = aws_dynamodb_table.app.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "gracenote_showtime_coordinator" {
  function_name = "${var.app}-gracenote-showtime-coordinator-lambda"
  role          = aws_iam_role.gracenote_showtime_coordinator_lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"
  timeout       = var.gracenote_coordinator_timeout_seconds
  memory_size   = var.gracenote_coordinator_memory_size

  environment {
    variables = {
      APP_TABLE_NAME             = aws_dynamodb_table.app.name
      SHOWTIME_REFRESH_QUEUE_URL = aws_sqs_queue.gracenote_showtime_refresh_queue.id
      GRACENOTE_DEFAULT_ZIP      = var.gracenote_default_zip
      GRACENOTE_DEFAULT_RADIUS   = tostring(var.gracenote_default_radius)
      GRACENOTE_DEFAULT_NUM_DAYS = tostring(var.gracenote_default_num_days)
      GRACENOTE_UNITS            = var.gracenote_units
      MOVIE_CLUB_TIMEZONE        = var.movie_club_timezone
      LOG_LEVEL                  = "INFO"
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "gracenote_showtime_worker" {
  function_name = "${var.app}-gracenote-showtime-worker-lambda"
  role          = aws_iam_role.gracenote_showtime_worker_lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"
  timeout       = var.gracenote_worker_timeout_seconds
  memory_size   = var.gracenote_worker_memory_size

  environment {
    variables = {
      APP_TABLE_NAME             = aws_dynamodb_table.app.name
      GRACENOTE_SECRET_ARN       = aws_secretsmanager_secret.gracenote_api_key.arn
      GRACENOTE_BASE_URL         = var.gracenote_base_url
      GRACENOTE_DEFAULT_ZIP      = var.gracenote_default_zip
      GRACENOTE_DEFAULT_RADIUS   = tostring(var.gracenote_default_radius)
      GRACENOTE_DEFAULT_NUM_DAYS = tostring(var.gracenote_default_num_days)
      GRACENOTE_UNITS            = var.gracenote_units
      GRACENOTE_IMAGE_SIZE       = var.gracenote_image_size
      GRACENOTE_IMAGE_TEXT       = tostring(var.gracenote_image_text)
      MOVIE_CLUB_TIMEZONE        = var.movie_club_timezone
      LOG_LEVEL                  = "INFO"
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_event_source_mapping" "gracenote_showtime_refresh_sqs_trigger" {
  event_source_arn                   = aws_sqs_queue.gracenote_showtime_refresh_queue.arn
  function_name                      = aws_lambda_function.gracenote_showtime_worker.arn
  batch_size                         = 5
  maximum_batching_window_in_seconds = 10
  enabled                            = true
}

resource "aws_lambda_event_source_mapping" "admin_selection_sqs_trigger" {
  event_source_arn = aws_sqs_queue.admin_selection.arn
  function_name    = aws_lambda_function.movie_scraper.arn
  batch_size       = 1
  enabled          = true
}

resource "aws_lambda_function" "vote_handler" {
  function_name = "${var.app}-vote-handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = {
      APP_TABLE_NAME = aws_dynamodb_table.app.name
      VOTE_TABLE     = aws_dynamodb_table.app.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "get_selection" {
  function_name = "${var.app}-get-selection-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = {
      APP_TABLE_NAME               = aws_dynamodb_table.app.name
      MOVIE_SHOWTIME_OPTIONS_TABLE = aws_dynamodb_table.app.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "get_options" {
  function_name = "${var.app}-get-options-lambda"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = {
      APP_TABLE_NAME               = aws_dynamodb_table.app.name
      MOVIE_SHOWTIME_OPTIONS_TABLE = aws_dynamodb_table.app.name
    }
  }

  tags = local.common_tags
}

resource "aws_lambda_function" "app_handlers" {
  for_each = local.app_lambda_handlers

  function_name = each.value.function_name
  role          = each.key == "movie_search" ? aws_iam_role.movie_search_lambda_role.arn : aws_iam_role.lambda_role.arn
  runtime       = "python3.13"
  handler       = "app.handler"
  filename      = "${path.module}/placeholder_lambda/placeholder_lambda.zip"

  environment {
    variables = merge(
      {
        APP_TABLE_NAME = aws_dynamodb_table.app.name
      },
      each.key == "movie_search" ? {
        TMDB_SECRET_ARN = aws_secretsmanager_secret.tmdb_api_token.arn
        TMDB_BASE_URL   = var.tmdb_base_url
      } : {},
      each.key == "manage_invites" ? {
        APP_BASE_URL      = var.movie_club_app_base_url
        INVITE_EMAIL_FROM = var.movie_club_invite_email_from
      } : {},
      each.key == "manage_showtimes" ? {
        SHOWTIME_REFRESH_QUEUE_URL = aws_sqs_queue.gracenote_showtime_refresh_queue.id
      } : {}
    )
  }

  lifecycle {
    ignore_changes = [filename]
  }

  tags = local.common_tags
}
