output "gracenote_secret_arn" {
  description = "ARN of the Secrets Manager secret that stores the Gracenote/TMS API key."
  value       = aws_secretsmanager_secret.gracenote_api_key.arn
}

output "gracenote_showtime_refresh_queue_url" {
  description = "URL of the Gracenote showtime refresh SQS queue."
  value       = aws_sqs_queue.gracenote_showtime_refresh_queue.id
}

output "gracenote_showtime_refresh_queue_arn" {
  description = "ARN of the Gracenote showtime refresh SQS queue."
  value       = aws_sqs_queue.gracenote_showtime_refresh_queue.arn
}

output "gracenote_showtime_worker_lambda_name" {
  description = "Name of the Gracenote showtime worker Lambda."
  value       = aws_lambda_function.gracenote_showtime_worker.function_name
}

output "gracenote_showtime_coordinator_lambda_name" {
  description = "Name of the Gracenote showtime coordinator Lambda."
  value       = aws_lambda_function.gracenote_showtime_coordinator.function_name
}

output "gracenote_showtime_refresh_schedule_name" {
  description = "Name of the EventBridge rule that schedules Gracenote showtime refreshes."
  value       = aws_cloudwatch_event_rule.gracenote_showtime_refresh.name
}
