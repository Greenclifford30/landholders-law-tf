variable "owner_email" {
  type        = string
  default     = "greenclifford30@gmail.com"
  description = "Email of the business owner to receive notifications."
}

variable "business_email" {
  type        = string
  default     = "assistant@landholderslaw.com"
  description = "Email of the business owner to receive notifications."
}

# ses.tf
variable "ses_domain_name" {
  type        = string
  default     = "landholderslaw.com"
  description = "Domain name to verify for SES."
}

variable "google_verification_value" {
  type = string
  description = "google verification"
}

variable "app" { 
  type = string
  default = "sinful-delights"
}

variable "google_client_id" {}
variable "google_client_secret" {}

variable "apple_services_id" {}
variable "apple_team_id" {}
variable "apple_key_id" {}
variable "apple_private_key" {
  sensitive = true
}
