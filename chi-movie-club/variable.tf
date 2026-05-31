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
  default     = true
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
