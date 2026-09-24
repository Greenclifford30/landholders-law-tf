# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

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
  type        = string
  description = "google verification"
}

variable "cmc_google_verification_value" {
  type = string
}

variable "chimovieclub_cognito_domain_prefix" {
  type        = string
  description = "Globally unique Cognito Hosted UI domain prefix for Chi Movie Club."
}

variable "chimovieclub_cognito_google_client_id" {
  type        = string
  description = "Google OAuth client ID for Chi Movie Club Cognito federation."
  sensitive   = true
}

variable "chimovieclub_cognito_google_client_secret" {
  type        = string
  description = "Google OAuth client secret for Chi Movie Club Cognito federation."
  sensitive   = true
}

variable "chimovieclub_cognito_callback_urls" {
  type        = list(string)
  description = "Allowed Chi Movie Club Cognito OAuth callback URLs."
  default     = ["https://chicagomovieclub.app/callback", "http://localhost:3000/auth/callback"]
}

variable "chimovieclub_cognito_logout_urls" {
  type        = list(string)
  description = "Allowed Chi Movie Club Cognito OAuth sign-out redirect URLs."
  default     = ["https://chicagomovieclub.app/sign-in", "http://localhost:3000/sign-in"]
}


variable "movie_club_web_push_vapid_public_key" {
  type        = string
  description = "Base64url VAPID public key used by the Movie Club web client to create browser push subscriptions."
  default     = ""
}

variable "movie_club_web_push_vapid_private_key" {
  type        = string
  description = "Base64url VAPID private key used only by the notification worker to sign browser push messages."
  sensitive   = true
  default     = ""
}

variable "movie_club_web_push_vapid_claims_email" {
  type        = string
  description = "Contact email used in the VAPID subject claim, for example mailto:you@chicagomovieclub.app"
  default     = "mailto:you@chicagomovieclub.app"
}