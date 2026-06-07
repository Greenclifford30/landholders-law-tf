variable "owner_email" {
  type        = string
  default     = "greenclifford30@gmail.com"
  description = "Email of the business owner to receive notifications."
}

variable "business_email" {
  type        = string
  default     = "assistant@onewayelectric.com"
  description = "Email of the business owner to receive notifications."
}

# ses.tf
variable "ses_domain_name" {
  type        = string
  default     = "onewayelectric.com"
  description = "Domain name to verify for SES."
}

variable "google_verification_value" {
  type = string
  description = "google verification"
}

variable "app" {
  type        = string
  description = "application name"
  default     = "cmc"
}

variable "gracenote_base_url" {
  type        = string
  description = "Base URL for the Gracenote/TMS API."
  default     = "http://data.tmsapi.com/v1.1"
}

variable "gracenote_secret_name" {
  type        = string
  description = "Secrets Manager secret name for the Gracenote/TMS API key. The secret value is populated outside Terraform."
  default     = "/cmc/production/gracenote/api-key"
}

variable "gracenote_default_zip" {
  type        = string
  description = "Default ZIP code used for Gracenote showtime refreshes."
  default     = "60422"
}

variable "gracenote_default_radius" {
  type        = number
  description = "Default theater search radius for Gracenote showtime refreshes."
  default     = 30

  validation {
    condition     = var.gracenote_default_radius >= 1 && var.gracenote_default_radius <= 100
    error_message = "gracenote_default_radius must be between 1 and 100."
  }
}

variable "gracenote_default_num_days" {
  type        = number
  description = "Default number of days to request from Gracenote."
  default     = 14

  validation {
    condition     = var.gracenote_default_num_days >= 1 && var.gracenote_default_num_days <= 90
    error_message = "gracenote_default_num_days must be between 1 and 90."
  }
}

variable "gracenote_units" {
  type        = string
  description = "Distance unit for Gracenote radius searches."
  default     = "mi"

  validation {
    condition     = contains(["mi", "km"], var.gracenote_units)
    error_message = "gracenote_units must be either \"mi\" or \"km\"."
  }
}

variable "gracenote_image_size" {
  type        = string
  description = "Preferred image size requested from Gracenote."
  default     = "Md"
}

variable "gracenote_image_text" {
  type        = bool
  description = "Whether Gracenote image responses should include text in images."
  default     = true
}

variable "movie_club_timezone" {
  type        = string
  description = "Movie Club local timezone for normalizing showtimes."
  default     = "America/Chicago"
}

variable "tmdb_secret_name" {
  type        = string
  description = "Secrets Manager secret name for the TMDB API token. The secret value is populated outside Terraform."
  default     = "/cmc/production/tmdb/api-token"
}

variable "cognito_domain_prefix" {
  type        = string
  description = "Globally unique Cognito Hosted UI domain prefix, without the auth region suffix."

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])?$", var.cognito_domain_prefix))
    error_message = "cognito_domain_prefix must be 3-63 lowercase letters, numbers, or hyphens, and cannot start or end with a hyphen."
  }
}

variable "cognito_google_client_id" {
  type        = string
  description = "Google OAuth client ID for Cognito Hosted UI federation."
  sensitive   = true
}

variable "cognito_google_client_secret" {
  type        = string
  description = "Google OAuth client secret for Cognito Hosted UI federation."
  sensitive   = true
}

variable "cognito_callback_urls" {
  type        = list(string)
  description = "Allowed Cognito OAuth callback URLs. Include local and production /auth/callback URLs."
  default     = ["http://localhost:3000/auth/callback"]
}

variable "cognito_logout_urls" {
  type        = list(string)
  description = "Allowed Cognito OAuth sign-out redirect URLs."
  default     = ["http://localhost:3000/sign-in"]
}

variable "cognito_oauth_scopes" {
  type        = list(string)
  description = "OAuth scopes requested by the Cognito app client."
  default     = ["openid", "email", "profile"]
}

variable "cognito_google_oauth_scopes" {
  type        = list(string)
  description = "OAuth scopes requested from Google by the Cognito identity provider."
  default     = ["openid", "email", "profile"]
}

variable "tmdb_base_url" {
  type        = string
  description = "Base URL for TMDB API calls."
  default     = "https://api.themoviedb.org/3"
}

variable "movie_club_app_base_url" {
  type        = string
  description = "Public Movie Club app URL used in invite links."
  default     = "http://localhost:3000"
}

variable "movie_club_invite_email_from" {
  type        = string
  description = "Verified SES sender email address for Movie Club invite emails. If empty, invite records are created without sending email."
  default     = ""
}

variable "gracenote_refresh_schedule_enabled" {
  type        = bool
  description = "Whether the scheduled Gracenote showtime refresh is enabled."
  default     = false
}

variable "gracenote_refresh_schedule_expression" {
  type        = string
  description = "EventBridge schedule expression for Gracenote showtime refreshes. 11 UTC is roughly morning in Chicago depending on daylight savings."
  default     = "cron(0 11 * * ? *)"
}

variable "gracenote_worker_timeout_seconds" {
  type        = number
  description = "Timeout in seconds for the Gracenote showtime worker Lambda."
  default     = 60
}

variable "gracenote_worker_memory_size" {
  type        = number
  description = "Memory size in MB for the Gracenote showtime worker Lambda."
  default     = 512
}

variable "gracenote_coordinator_timeout_seconds" {
  type        = number
  description = "Timeout in seconds for the Gracenote showtime coordinator Lambda."
  default     = 30
}

variable "gracenote_coordinator_memory_size" {
  type        = number
  description = "Memory size in MB for the Gracenote showtime coordinator Lambda."
  default     = 256
}

variable "dynamodb_point_in_time_recovery_enabled" {
  type        = bool
  description = "Whether DynamoDB point-in-time recovery is enabled. Keep false during tiny launch; enable before broader public availability if vote/history recovery matters."
  default     = false
}

variable "lambda_log_retention_days" {
  type        = number
  description = "CloudWatch Logs retention in days for Chi Movie Club Lambda log groups."
  default     = 14
}

variable "monthly_budget_limit_usd" {
  type        = string
  description = "Low monthly spend guardrail for Chi Movie Club tagged resources."
  default     = "10"
}

variable "critical_monthly_budget_limit_usd" {
  type        = string
  description = "Higher monthly spend guardrail that indicates unexpected Chi Movie Club cost growth."
  default     = "25"
}
