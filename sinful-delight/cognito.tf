resource "aws_cognito_user_pool" "main" {
  name = "sinful-delights-user-pool"

  auto_verified_attributes = ["email"]

  alias_attributes = ["email"]

  mfa_configuration = "ON"

  software_token_mfa_configuration {
    enabled = true
  }

  sms_configuration {
    external_id    = "your-external-id"
    sns_caller_arn = "arn:aws:iam::<account-id>:role/<sns-role>"
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }

  username_configuration {
    case_sensitive = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "sinful-delights-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret = false

  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]
  allowed_oauth_flows_user_pool_client = true

  callback_urls = ["https://your-app.com/callback"]
  logout_urls   = ["https://your-app.com/logout"]

  supported_identity_providers = ["COGNITO", "Google", "SignInWithApple"]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH"
  ]
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret
    authorize_scopes = "profile email openid"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "apple" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "SignInWithApple"
  provider_type = "SignInWithApple"

  provider_details = {
    client_id     = var.apple_services_id
    team_id       = var.apple_team_id
    key_id        = var.apple_key_id
    private_key   = var.apple_private_key
    authorize_scopes = "name email"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "sinful-delights-auth"
  user_pool_id = aws_cognito_user_pool.main.id
}