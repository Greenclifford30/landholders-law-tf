resource "aws_secretsmanager_secret" "google_calendar_oauth" {
  name        = var.google_calendar_secret_name
  description = "Dedicated Google Calendar OAuth web-client credentials. Populate client_id and client_secret outside Terraform."
  tags        = local.common_tags
}

resource "aws_kms_key" "google_calendar_tokens" {
  description             = "Encrypts per-user Google Calendar refresh tokens."
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags                    = local.common_tags
}

resource "aws_kms_alias" "google_calendar_tokens" {
  name          = "alias/${var.app}-google-calendar-tokens"
  target_key_id = aws_kms_key.google_calendar_tokens.key_id
}

resource "aws_sqs_queue" "calendar_sync_dlq" {
  name                      = "${var.app}-calendar-sync-dlq"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
  tags                      = local.common_tags
}

resource "aws_sqs_queue" "calendar_sync" {
  name                       = "${var.app}-calendar-sync"
  visibility_timeout_seconds = var.calendar_sync_worker_timeout_seconds * 6
  message_retention_seconds  = 345600
  sqs_managed_sse_enabled    = true
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.calendar_sync_dlq.arn
    maxReceiveCount     = 4
  })
  tags = local.common_tags
}

resource "aws_lambda_event_source_mapping" "calendar_sync_worker" {
  event_source_arn                   = aws_sqs_queue.calendar_sync.arn
  function_name                      = aws_lambda_function.app_handlers["calendar_sync_worker"].arn
  batch_size                         = 5
  function_response_types            = ["ReportBatchItemFailures"]
  maximum_batching_window_in_seconds = 5
}

resource "aws_cloudwatch_event_rule" "calendar_sync" {
  name                = "${var.app}-calendar-sync"
  description         = "Queues hourly refreshes for connected Google calendars."
  schedule_expression = var.calendar_sync_schedule_expression
  state               = var.google_calendar_feature_enabled ? "ENABLED" : "DISABLED"
  tags                = local.common_tags
}

resource "aws_cloudwatch_event_target" "calendar_sync" {
  rule      = aws_cloudwatch_event_rule.calendar_sync.name
  target_id = "calendar-sync-coordinator"
  arn       = aws_lambda_function.app_handlers["calendar_sync_coordinator"].arn
}

resource "aws_lambda_permission" "allow_eventbridge_calendar_sync" {
  statement_id  = "AllowEventBridgeInvokeCalendarSync"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app_handlers["calendar_sync_coordinator"].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.calendar_sync.arn
}

resource "aws_cloudwatch_metric_alarm" "calendar_sync_oldest_message" {
  alarm_name          = "${var.app}-calendar-sync-oldest-message"
  alarm_description   = "Calendar sync queue has work older than two hours."
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateAgeOfOldestMessage"
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 2
  threshold           = 7200
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { QueueName = aws_sqs_queue.calendar_sync.name }
  tags                = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "calendar_sync_dlq_visible" {
  alarm_name          = "${var.app}-calendar-sync-dlq-visible"
  alarm_description   = "A Google Calendar sync message exhausted its retries."
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  statistic           = "Maximum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"
  treat_missing_data  = "notBreaching"
  dimensions          = { QueueName = aws_sqs_queue.calendar_sync_dlq.name }
  tags                = local.common_tags
}

resource "aws_iam_role" "calendar_integration_lambda_role" {
  name               = "${var.app}-calendar-integration-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags               = local.common_tags
}
resource "aws_iam_role_policy_attachment" "calendar_integration_basic" {
  role       = aws_iam_role.calendar_integration_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "calendar_integration" {
  name = "${var.app}-calendar-integration"
  role = aws_iam_role.calendar_integration_lambda_role.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [
    { Effect = "Allow", Action = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem", "dynamodb:Query"], Resource = [aws_dynamodb_table.app.arn, "${aws_dynamodb_table.app.arn}/index/GSI1", "${aws_dynamodb_table.app.arn}/index/GSI2"] },
    { Effect = "Allow", Action = ["kms:Encrypt", "kms:Decrypt"], Resource = aws_kms_key.google_calendar_tokens.arn },
    { Effect = "Allow", Action = ["secretsmanager:GetSecretValue"], Resource = aws_secretsmanager_secret.google_calendar_oauth.arn },
    { Effect = "Allow", Action = ["sqs:SendMessage"], Resource = aws_sqs_queue.calendar_sync.arn },
  ] })
}

resource "aws_iam_role" "calendar_sync_worker_lambda_role" {
  name               = "${var.app}-calendar-sync-worker-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags               = local.common_tags
}
resource "aws_iam_role_policy_attachment" "calendar_sync_worker_basic" {
  role       = aws_iam_role.calendar_sync_worker_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "calendar_sync_worker" {
  name = "${var.app}-calendar-sync-worker"
  role = aws_iam_role.calendar_sync_worker_lambda_role.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [
    { Effect = "Allow", Action = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query"], Resource = [aws_dynamodb_table.app.arn, "${aws_dynamodb_table.app.arn}/index/GSI1", "${aws_dynamodb_table.app.arn}/index/GSI2"] },
    { Effect = "Allow", Action = ["kms:Decrypt"], Resource = aws_kms_key.google_calendar_tokens.arn },
    { Effect = "Allow", Action = ["secretsmanager:GetSecretValue"], Resource = aws_secretsmanager_secret.google_calendar_oauth.arn },
    { Effect = "Allow", Action = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes", "sqs:ChangeMessageVisibility"], Resource = aws_sqs_queue.calendar_sync.arn },
  ] })
}

resource "aws_iam_role" "calendar_sync_coordinator_lambda_role" {
  name               = "${var.app}-calendar-sync-coordinator-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags               = local.common_tags
}
resource "aws_iam_role_policy_attachment" "calendar_sync_coordinator_basic" {
  role       = aws_iam_role.calendar_sync_coordinator_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "calendar_sync_coordinator" {
  name = "${var.app}-calendar-sync-coordinator"
  role = aws_iam_role.calendar_sync_coordinator_lambda_role.id
  policy = jsonencode({ Version = "2012-10-17", Statement = [
    { Effect = "Allow", Action = ["dynamodb:Query"], Resource = "${aws_dynamodb_table.app.arn}/index/GSI1" },
    { Effect = "Allow", Action = ["sqs:SendMessage"], Resource = aws_sqs_queue.calendar_sync.arn },
  ] })
}

# Google Calendar integration and event availability API resources.
resource "aws_api_gateway_resource" "me_integrations" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.me.id
  path_part   = "integrations"
}
resource "aws_api_gateway_resource" "me_google_calendar" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.me_integrations.id
  path_part   = "google-calendar"
}
resource "aws_api_gateway_resource" "me_google_calendar_authorize" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.me_google_calendar.id
  path_part   = "authorize"
}
resource "aws_api_gateway_resource" "me_google_calendar_calendars" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.me_google_calendar.id
  path_part   = "calendars"
}
resource "aws_api_gateway_resource" "me_google_calendar_sync" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.me_google_calendar.id
  path_part   = "sync"
}
resource "aws_api_gateway_resource" "integrations" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "integrations"
}
resource "aws_api_gateway_resource" "google_calendar" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.integrations.id
  path_part   = "google-calendar"
}
resource "aws_api_gateway_resource" "google_calendar_callback" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.google_calendar.id
  path_part   = "callback"
}
resource "aws_api_gateway_resource" "club_members_me" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_members.id
  path_part   = "me"
}
resource "aws_api_gateway_resource" "movie_night_availability" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "availability"
}
resource "aws_api_gateway_resource" "movie_night_availability_me" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_availability.id
  path_part   = "me"
}

locals {
  calendar_api_routes = {
    google_status        = { resource_id = aws_api_gateway_resource.me_google_calendar.id, method = "GET", handler = "manage_calendar_integration", auth = true }
    google_select        = { resource_id = aws_api_gateway_resource.me_google_calendar.id, method = "PUT", handler = "manage_calendar_integration", auth = true }
    google_disconnect    = { resource_id = aws_api_gateway_resource.me_google_calendar.id, method = "DELETE", handler = "manage_calendar_integration", auth = true }
    google_authorize     = { resource_id = aws_api_gateway_resource.me_google_calendar_authorize.id, method = "POST", handler = "manage_calendar_integration", auth = true }
    google_calendars     = { resource_id = aws_api_gateway_resource.me_google_calendar_calendars.id, method = "GET", handler = "manage_calendar_integration", auth = true }
    google_sync          = { resource_id = aws_api_gateway_resource.me_google_calendar_sync.id, method = "POST", handler = "manage_calendar_integration", auth = true }
    google_callback      = { resource_id = aws_api_gateway_resource.google_calendar_callback.id, method = "GET", handler = "manage_calendar_integration", auth = false }
    club_member_settings = { resource_id = aws_api_gateway_resource.club_members_me.id, method = "PATCH", handler = "manage_clubs", auth = true }
    availability_get     = { resource_id = aws_api_gateway_resource.movie_night_availability.id, method = "GET", handler = "manage_availability", auth = true }
    availability_put     = { resource_id = aws_api_gateway_resource.movie_night_availability_me.id, method = "PUT", handler = "manage_availability", auth = true }
    availability_delete  = { resource_id = aws_api_gateway_resource.movie_night_availability_me.id, method = "DELETE", handler = "manage_availability", auth = true }
  }
}

resource "aws_api_gateway_method" "calendar_routes" {
  for_each         = local.calendar_api_routes
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = each.value.resource_id
  http_method      = each.value.method
  authorization    = each.value.auth ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id    = each.value.auth ? aws_api_gateway_authorizer.cognito.id : null
  api_key_required = true
}

resource "aws_api_gateway_integration" "calendar_routes" {
  for_each                = local.calendar_api_routes
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = each.value.resource_id
  http_method             = aws_api_gateway_method.calendar_routes[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers[each.value.handler].invoke_arn
}
