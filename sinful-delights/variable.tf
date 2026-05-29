variable "owner_email" {
  type        = string
  default     = "greenclifford30@gmail.com"
  description = "Email of the business owner to receive notifications."
}

variable "business_email" {
  type        = string
  default     = "assistant@sinfuldelights.com"
  description = "Email of the business owner to receive notifications."
}

# ses.tf
variable "ses_domain_name" {
  type        = string
  default     = "sinfuldelights.com"
  description = "Domain name to verify for SES."
}

variable "google_verification_value" {
  type = string
  description = "google verification"
}

variable "app" {
  type = string
  description = "application name"
  default = "sinful-delights"
}

variable "app_upper_camel" {
  type = string
  description = "application name"
  default = "SinfulDelights"
}
variable "app_underscore" {
  type = string
  description = "application name"
  default = "sinful_delights"
}
