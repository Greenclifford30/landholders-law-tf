resource "aws_cognito_user_pool" "main" {
  name = "${var.app}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  tags = {
    Environment = "production"
    Project     = "ChiMovieClub"
    ManagedBy   = "Terraform"
  }
}

resource "aws_cognito_user_pool_client" "web" {
  name         = "${var.app}-web-client"
  user_pool_id = aws_cognito_user_pool.main.id

  generate_secret                      = false
  prevent_user_existence_errors        = "ENABLED"
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows_user_pool_client = false

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
}

resource "aws_cognito_user_group" "admin" {
  name         = "Admin"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Movie Club administrators who can manage clubs and movie nights."
  precedence   = 1
}

resource "aws_cognito_user_group" "friend" {
  name         = "Friend"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Movie Club members who can vote, RSVP, and view history."
  precedence   = 10
}

resource "aws_cognito_user_group" "guest" {
  name         = "Guest"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Invited Movie Club guests with event-scoped participation."
  precedence   = 20
}

resource "aws_api_gateway_authorizer" "cognito" {
  name          = "${var.app}-cognito-authorizer"
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.main.arn]
}
