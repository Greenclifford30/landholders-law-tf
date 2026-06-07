output "chimovieclub_gracenote_secret_arn" {
  description = "ARN of the Secrets Manager secret that stores the Chi Movie Club Gracenote/TMS API key."
  value       = module.chimovieclub.gracenote_secret_arn
}

output "chimovieclub_gracenote_showtime_refresh_queue_url" {
  description = "URL of the Chi Movie Club Gracenote showtime refresh SQS queue."
  value       = module.chimovieclub.gracenote_showtime_refresh_queue_url
}

output "chimovieclub_gracenote_showtime_refresh_queue_arn" {
  description = "ARN of the Chi Movie Club Gracenote showtime refresh SQS queue."
  value       = module.chimovieclub.gracenote_showtime_refresh_queue_arn
}

output "chimovieclub_gracenote_showtime_worker_lambda_name" {
  description = "Name of the Chi Movie Club Gracenote showtime worker Lambda."
  value       = module.chimovieclub.gracenote_showtime_worker_lambda_name
}

output "chimovieclub_gracenote_showtime_coordinator_lambda_name" {
  description = "Name of the Chi Movie Club Gracenote showtime coordinator Lambda."
  value       = module.chimovieclub.gracenote_showtime_coordinator_lambda_name
}

output "chimovieclub_gracenote_showtime_refresh_schedule_name" {
  description = "Name of the EventBridge rule that schedules Chi Movie Club Gracenote showtime refreshes."
  value       = module.chimovieclub.gracenote_showtime_refresh_schedule_name
}

output "chimovieclub_cognito_user_pool_id" {
  description = "Cognito user pool ID for NEXT_PUBLIC_COGNITO_USER_POOL_ID."
  value       = module.chimovieclub.cognito_user_pool_id
}

output "chimovieclub_cognito_web_client_id" {
  description = "Cognito app client ID for NEXT_PUBLIC_COGNITO_USER_POOL_CLIENT_ID."
  value       = module.chimovieclub.cognito_web_client_id
}

output "chimovieclub_cognito_region" {
  description = "AWS region for NEXT_PUBLIC_AWS_REGION."
  value       = module.chimovieclub.cognito_region
}

output "chimovieclub_cognito_hosted_ui_domain" {
  description = "Cognito Hosted UI domain for NEXT_PUBLIC_COGNITO_DOMAIN."
  value       = module.chimovieclub.cognito_hosted_ui_domain
}

output "chimovieclub_cognito_google_idp_callback_url" {
  description = "Callback URL to configure in the Google OAuth client."
  value       = module.chimovieclub.cognito_google_idp_callback_url
}
