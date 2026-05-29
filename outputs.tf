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
