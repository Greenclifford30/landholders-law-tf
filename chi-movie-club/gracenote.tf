locals {
  common_tags = {
    Environment = "production"
    Project     = "ChiMovieClub"
    ManagedBy   = "Terraform"
  }
}

resource "aws_secretsmanager_secret" "gracenote_api_key" {
  name        = var.gracenote_secret_name
  description = "Stores the Gracenote/TMS API key for Movie Club showtime ingestion. Populate the secret value outside Terraform."

  tags = local.common_tags
}

resource "aws_cloudwatch_event_rule" "gracenote_showtime_refresh" {
  name                = "${var.app}-gracenote-showtime-refresh"
  description         = "Scheduled Gracenote showtime refresh for Movie Club."
  schedule_expression = var.gracenote_refresh_schedule_expression
  state               = var.gracenote_refresh_schedule_enabled ? "ENABLED" : "DISABLED"

  tags = local.common_tags
}

resource "aws_cloudwatch_event_target" "gracenote_showtime_refresh" {
  rule      = aws_cloudwatch_event_rule.gracenote_showtime_refresh.name
  target_id = "gracenote-showtime-coordinator"
  arn       = aws_lambda_function.gracenote_showtime_coordinator.arn

  input = jsonencode({
    source   = "eventbridge"
    provider = "gracenote"
    zip      = var.gracenote_default_zip
    radius   = var.gracenote_default_radius
    numDays  = var.gracenote_default_num_days
    units    = var.gracenote_units
  })
}

resource "aws_lambda_permission" "allow_eventbridge_gracenote_showtime_refresh" {
  statement_id  = "AllowEventBridgeInvokeGracenoteShowtimeRefresh"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gracenote_showtime_coordinator.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.gracenote_showtime_refresh.arn
}
