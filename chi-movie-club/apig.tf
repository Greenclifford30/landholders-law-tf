#########################################
# 1) Create a REST API in API Gateway
#########################################
resource "aws_api_gateway_rest_api" "chimovieclub_api" {
  name        = "${var.app}-api"
  description = "Handles One Way Chi Movie Club API requests"

  tags = local.common_tags
}

resource "aws_api_gateway_deployment" "cmc_deployment" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.movies.id,
      aws_api_gateway_resource.movies_search.id,
      aws_api_gateway_resource.movies_now_playing.id,
      aws_api_gateway_resource.clubs.id,
      aws_api_gateway_resource.club_id.id,
      aws_api_gateway_resource.club_invites.id,
      aws_api_gateway_resource.invites.id,
      aws_api_gateway_resource.invite_token.id,
      aws_api_gateway_resource.invite_accept.id,
      aws_api_gateway_resource.club_movie_nights.id,
      aws_api_gateway_resource.club_movie_nights_active.id,
      aws_api_gateway_resource.club_movie_nights_history.id,
      aws_api_gateway_resource.movie_nights.id,
      aws_api_gateway_resource.movie_night_id.id,
      aws_api_gateway_resource.movie_night_showtimes.id,
      aws_api_gateway_resource.movie_night_vote.id,
      aws_api_gateway_resource.movie_night_vote_results.id,
      aws_api_gateway_resource.movie_night_confirm.id,
      aws_api_gateway_resource.movie_night_complete.id,
      aws_api_gateway_resource.movie_night_rsvp.id,
      aws_api_gateway_resource.admin_showtimes.id,
      aws_api_gateway_resource.admin_showtimes_gracenote.id,
      aws_api_gateway_resource.admin_showtimes_gracenote_refresh.id,
      aws_api_gateway_resource.admin_showtimes_gracenote_search.id,
      aws_api_gateway_method.get_movies_search.id,
      aws_api_gateway_method.get_movies_now_playing.id,
      aws_api_gateway_method.get_clubs.id,
      aws_api_gateway_method.post_clubs.id,
      aws_api_gateway_method.post_club_invites.id,
      aws_api_gateway_method.get_club_invites.id,
      aws_api_gateway_method.get_invite.id,
      aws_api_gateway_method.post_accept_invite.id,
      aws_api_gateway_method.post_club_movie_nights.id,
      aws_api_gateway_method.get_active_movie_night.id,
      aws_api_gateway_method.get_movie_night_history.id,
      aws_api_gateway_method.post_movie_night_showtimes.id,
      aws_api_gateway_method.put_movie_night_vote.id,
      aws_api_gateway_method.get_movie_night_vote_results.id,
      aws_api_gateway_method.post_movie_night_confirm.id,
      aws_api_gateway_method.post_movie_night_complete.id,
      aws_api_gateway_method.put_movie_night_rsvp.id,
      aws_api_gateway_method.post_admin_showtimes_gracenote_refresh.id,
      aws_api_gateway_method.get_admin_showtimes_gracenote_search.id,
      aws_api_gateway_integration.get_movies_search_integration.id,
      aws_api_gateway_integration.get_movies_now_playing_integration.id,
      aws_api_gateway_integration.get_clubs_integration.id,
      aws_api_gateway_integration.post_clubs_integration.id,
      aws_api_gateway_integration.post_club_invites_integration.id,
      aws_api_gateway_integration.get_club_invites_integration.id,
      aws_api_gateway_integration.get_invite_integration.id,
      aws_api_gateway_integration.post_accept_invite_integration.id,
      aws_api_gateway_integration.post_club_movie_nights_integration.id,
      aws_api_gateway_integration.get_active_movie_night_integration.id,
      aws_api_gateway_integration.get_movie_night_history_integration.id,
      aws_api_gateway_integration.post_movie_night_showtimes_integration.id,
      aws_api_gateway_integration.put_movie_night_vote_integration.id,
      aws_api_gateway_integration.get_movie_night_vote_results_integration.id,
      aws_api_gateway_integration.post_movie_night_confirm_integration.id,
      aws_api_gateway_integration.post_movie_night_complete_integration.id,
      aws_api_gateway_integration.put_movie_night_rsvp_integration.id,
      aws_api_gateway_integration.post_admin_showtimes_gracenote_refresh_integration.id,
      aws_api_gateway_integration.get_admin_showtimes_gracenote_search_integration.id,
      aws_api_gateway_authorizer.cognito.id,
      values(aws_api_gateway_integration.cors_options_integration)[*].id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.post_admin_selection_integration,
    aws_api_gateway_integration.post_vote_integration,
    aws_api_gateway_integration.get_selection_integration,
    aws_api_gateway_integration.get_options_integration,
    aws_api_gateway_integration.get_movies_search_integration,
    aws_api_gateway_integration.get_movies_now_playing_integration,
    aws_api_gateway_integration.get_clubs_integration,
    aws_api_gateway_integration.post_clubs_integration,
    aws_api_gateway_integration.post_club_invites_integration,
    aws_api_gateway_integration.get_club_invites_integration,
    aws_api_gateway_integration.get_invite_integration,
    aws_api_gateway_integration.post_accept_invite_integration,
    aws_api_gateway_integration.post_club_movie_nights_integration,
    aws_api_gateway_integration.get_active_movie_night_integration,
    aws_api_gateway_integration.get_movie_night_history_integration,
    aws_api_gateway_integration.post_movie_night_showtimes_integration,
    aws_api_gateway_integration.put_movie_night_vote_integration,
    aws_api_gateway_integration.get_movie_night_vote_results_integration,
    aws_api_gateway_integration.post_movie_night_confirm_integration,
    aws_api_gateway_integration.post_movie_night_complete_integration,
    aws_api_gateway_integration.put_movie_night_rsvp_integration,
    aws_api_gateway_integration.post_admin_showtimes_gracenote_refresh_integration,
    aws_api_gateway_integration.get_admin_showtimes_gracenote_search_integration,
    aws_api_gateway_integration.cors_options_integration,
  ]
}

resource "aws_api_gateway_stage" "development" {
  deployment_id = aws_api_gateway_deployment.cmc_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  stage_name    = "development"

  tags = local.common_tags
}

resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "admin"
}

resource "aws_api_gateway_resource" "selection" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "selection"
}

resource "aws_api_gateway_resource" "admin_showtimes" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "showtimes"
}

resource "aws_api_gateway_resource" "admin_showtimes_gracenote" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.admin_showtimes.id
  path_part   = "gracenote"
}

resource "aws_api_gateway_resource" "admin_showtimes_gracenote_refresh" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.admin_showtimes_gracenote.id
  path_part   = "refresh"
}

resource "aws_api_gateway_resource" "admin_showtimes_gracenote_search" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.admin_showtimes_gracenote.id
  path_part   = "search"
}

resource "aws_api_gateway_resource" "vote" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "vote"
}

resource "aws_api_gateway_resource" "options" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "options"
}

resource "aws_api_gateway_resource" "movies" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "movies"
}

resource "aws_api_gateway_resource" "movies_search" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movies.id
  path_part   = "search"
}

resource "aws_api_gateway_resource" "movies_now_playing" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movies.id
  path_part   = "now-playing"
}

resource "aws_api_gateway_resource" "clubs" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "clubs"
}

resource "aws_api_gateway_resource" "club_id" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.clubs.id
  path_part   = "{clubId}"
}

resource "aws_api_gateway_resource" "club_invites" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_id.id
  path_part   = "invites"
}

resource "aws_api_gateway_resource" "invites" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "invites"
}

resource "aws_api_gateway_resource" "invite_token" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.invites.id
  path_part   = "{token}"
}

resource "aws_api_gateway_resource" "invite_accept" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.invite_token.id
  path_part   = "accept"
}

resource "aws_api_gateway_resource" "club_movie_nights" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_id.id
  path_part   = "movie-nights"
}

resource "aws_api_gateway_resource" "club_movie_nights_active" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_movie_nights.id
  path_part   = "active"
}

resource "aws_api_gateway_resource" "club_movie_nights_history" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_movie_nights.id
  path_part   = "history"
}

resource "aws_api_gateway_resource" "movie_nights" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "movie-nights"
}

resource "aws_api_gateway_resource" "movie_night_id" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_nights.id
  path_part   = "{movieNightId}"
}

resource "aws_api_gateway_resource" "movie_night_showtimes" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "showtimes"
}

resource "aws_api_gateway_resource" "movie_night_vote" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "vote"
}

resource "aws_api_gateway_resource" "movie_night_vote_results" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "vote-results"
}

resource "aws_api_gateway_resource" "movie_night_confirm" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "confirm"
}

resource "aws_api_gateway_resource" "movie_night_complete" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "complete"
}

resource "aws_api_gateway_resource" "movie_night_rsvp" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "rsvp"
}

resource "aws_api_gateway_usage_plan" "chimovieclub_usage_plan" {
  name = "${var.app}-api-usage-plan"

  # (Optional) Throttling settings
  throttle_settings {
    burst_limit = 100 # Max requests in a single burst
    rate_limit  = 50  # Steady-state requests per second
  }

  # (Optional) Quota settings
  quota_settings {
    limit  = 10000 # Max requests per month
    period = "MONTH"
  }

  # Associate this plan with your REST API’s stage
  api_stages {
    api_id = aws_api_gateway_rest_api.chimovieclub_api.id
    stage  = aws_api_gateway_stage.development.stage_name
  }

  tags = local.common_tags
}

resource "aws_api_gateway_api_key" "chimovieclub_api_key" {
  name        = "${var.app}-api-key"
  description = "API key for one way electric endpoints"
  enabled     = true

  tags = local.common_tags
}

resource "aws_api_gateway_usage_plan_key" "chimovieclub_law_api_key" {
  key_id        = aws_api_gateway_api_key.chimovieclub_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.chimovieclub_usage_plan.id
}


resource "aws_api_gateway_method" "selection_options" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.selection.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "selection_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = aws_api_gateway_method.selection_options.http_method
  type        = "MOCK"

  # A mock integration returns a static response (statusCode=200)
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

resource "aws_api_gateway_method_response" "selection_options_200" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = aws_api_gateway_method.selection_options.http_method
  status_code = 200

  # Each key must be set to 'true' to pass through the header
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "selection_options_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.selection.id
  http_method = aws_api_gateway_method.selection_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}


resource "aws_api_gateway_method" "get_options_options" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.options.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_options_options_integration" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.options.id
  http_method = aws_api_gateway_method.get_options_options.http_method
  type        = "MOCK"

  # A mock integration returns a static response (statusCode=200)
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

}

resource "aws_api_gateway_method_response" "get_options_options_200" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.options.id
  http_method = aws_api_gateway_method.get_options_options.http_method
  status_code = 200

  # Each key must be set to 'true' to pass through the header
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "get_options_options_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = aws_api_gateway_resource.options.id
  http_method = aws_api_gateway_method.get_options_options.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
