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

output "cognito_user_pool_id" {
  description = "Cognito user pool ID for NEXT_PUBLIC_COGNITO_USER_POOL_ID."
  value       = aws_cognito_user_pool.main.id
}

output "cognito_web_client_id" {
  description = "Cognito app client ID for NEXT_PUBLIC_COGNITO_USER_POOL_CLIENT_ID."
  value       = aws_cognito_user_pool_client.web.id
}

output "cognito_region" {
  description = "AWS region for NEXT_PUBLIC_AWS_REGION."
  value       = data.aws_region.current.name
}

output "cognito_hosted_ui_domain" {
  description = "Cognito Hosted UI domain for NEXT_PUBLIC_COGNITO_DOMAIN."
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}

output "cognito_google_idp_callback_url" {
  description = "Callback URL to configure in the Google OAuth client."
  value       = "https://${aws_cognito_user_pool_domain.main.domain}.auth.${data.aws_region.current.name}.amazoncognito.com/oauth2/idpresponse"
}
