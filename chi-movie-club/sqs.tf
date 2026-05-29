resource "aws_sqs_queue" "admin_selection" {
  name                       = "${var.app}-admin-selection-queue"
  visibility_timeout_seconds = 120
}

resource "aws_sqs_queue" "gracenote_showtime_refresh_dlq" {
  name                      = "${var.app}-gracenote-showtime-refresh-dlq"
  message_retention_seconds = 345600

  tags = local.common_tags
}

resource "aws_sqs_queue" "gracenote_showtime_refresh_queue" {
  name                       = "${var.app}-gracenote-showtime-refresh-queue"
  visibility_timeout_seconds = var.gracenote_worker_timeout_seconds * 6
  message_retention_seconds  = 345600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.gracenote_showtime_refresh_dlq.arn
    maxReceiveCount     = 3
  })

  tags = local.common_tags
}
