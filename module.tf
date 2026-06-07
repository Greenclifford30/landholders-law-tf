module landholderslaw {
    source = "./landholderslaw"
    google_verification_value = var.google_verification_value
}

module "onewayelectric" {
  source = "./onewayelectric"
}

module "chimovieclub" {
  source                       = "./chi-movie-club"
  google_verification_value    = ""
  owner_email                  = var.owner_email
  cognito_domain_prefix        = var.chimovieclub_cognito_domain_prefix
  cognito_google_client_id     = var.chimovieclub_cognito_google_client_id
  cognito_google_client_secret = var.chimovieclub_cognito_google_client_secret
  cognito_callback_urls        = var.chimovieclub_cognito_callback_urls
  cognito_logout_urls          = var.chimovieclub_cognito_logout_urls
}

# module "sinflul_delights" {
#   source = "./sinful-delights"
#   google_verification_value = ""
# }

module "stricklin" {
  source = "./stricklin"
}
