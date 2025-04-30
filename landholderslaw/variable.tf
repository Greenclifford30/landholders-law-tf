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