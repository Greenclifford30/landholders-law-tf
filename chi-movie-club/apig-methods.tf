# POST /admin/selection
resource "aws_api_gateway_method" "post_admin_selection" {
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = aws_api_gateway_resource.selection.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "post_admin_selection_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.selection.id
  http_method             = aws_api_gateway_method.post_admin_selection.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.admin_selection.invoke_arn
}

# POST /vote
resource "aws_api_gateway_method" "post_vote" {
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = aws_api_gateway_resource.vote.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "post_vote_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.vote.id
  http_method             = aws_api_gateway_method.post_vote.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.vote_handler.invoke_arn
}

# GET /selection
resource "aws_api_gateway_resource" "selection_get" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_rest_api.chimovieclub_api.root_resource_id
  path_part   = "selection"
}

resource "aws_api_gateway_method" "get_selection" {
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = aws_api_gateway_resource.selection_get.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "get_selection_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.selection_get.id
  http_method             = aws_api_gateway_method.get_selection.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_selection.invoke_arn
}

# GET /options
resource "aws_api_gateway_method" "get_options" {
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = aws_api_gateway_resource.options.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "get_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.options.id
  http_method             = aws_api_gateway_method.get_options.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.get_options.invoke_arn
}

# POST /admin/showtimes/gracenote/refresh
resource "aws_api_gateway_method" "post_admin_showtimes_gracenote_refresh" {
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = aws_api_gateway_resource.admin_showtimes_gracenote_refresh.id
  http_method      = "POST"
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.cognito.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "post_admin_showtimes_gracenote_refresh_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.admin_showtimes_gracenote_refresh.id
  http_method             = aws_api_gateway_method.post_admin_showtimes_gracenote_refresh.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.gracenote_showtime_coordinator.invoke_arn
}

# GET /admin/showtimes/gracenote/search
resource "aws_api_gateway_method" "get_admin_showtimes_gracenote_search" {
  rest_api_id      = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id      = aws_api_gateway_resource.admin_showtimes_gracenote_search.id
  http_method      = "GET"
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.cognito.id
  api_key_required = true
}

resource "aws_api_gateway_integration" "get_admin_showtimes_gracenote_search_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.admin_showtimes_gracenote_search.id
  http_method             = aws_api_gateway_method.get_admin_showtimes_gracenote_search.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.gracenote_showtime_coordinator.invoke_arn
}

resource "aws_lambda_permission" "allow_apig" {
  for_each = {
    admin_selection = aws_lambda_function.admin_selection
    vote_handler    = aws_lambda_function.vote_handler
    get_selection   = aws_lambda_function.get_selection
    get_options     = aws_lambda_function.get_options
  }

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chimovieclub_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apig_gracenote_showtime_coordinator" {
  statement_id  = "AllowAPIGatewayInvoke-gracenote-showtime-coordinator"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gracenote_showtime_coordinator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chimovieclub_api.execution_arn}/*/POST/admin/showtimes/gracenote/refresh"
}

resource "aws_lambda_permission" "allow_apig_gracenote_showtime_search" {
  statement_id  = "AllowAPIGatewayInvoke-gracenote-showtime-search"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.gracenote_showtime_coordinator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chimovieclub_api.execution_arn}/*/GET/admin/showtimes/gracenote/search"
}

locals {
  cors_resources = {
    movies_search             = aws_api_gateway_resource.movies_search.id
    movies_now_playing        = aws_api_gateway_resource.movies_now_playing.id
    clubs                     = aws_api_gateway_resource.clubs.id
    me_preferences            = aws_api_gateway_resource.me_preferences.id
    club_invites              = aws_api_gateway_resource.club_invites.id
    invite_token              = aws_api_gateway_resource.invite_token.id
    invite_accept             = aws_api_gateway_resource.invite_accept.id
    club_movie_nights         = aws_api_gateway_resource.club_movie_nights.id
    club_movie_nights_active  = aws_api_gateway_resource.club_movie_nights_active.id
    club_movie_nights_history = aws_api_gateway_resource.club_movie_nights_history.id
    movie_night_showtimes     = aws_api_gateway_resource.movie_night_showtimes.id
    movie_night_vote          = aws_api_gateway_resource.movie_night_vote.id
    movie_night_vote_results  = aws_api_gateway_resource.movie_night_vote_results.id
    movie_night_confirm       = aws_api_gateway_resource.movie_night_confirm.id
    movie_night_complete      = aws_api_gateway_resource.movie_night_complete.id
    movie_night_rsvp          = aws_api_gateway_resource.movie_night_rsvp.id
    admin_gracenote_refresh   = aws_api_gateway_resource.admin_showtimes_gracenote_refresh.id
    admin_gracenote_search    = aws_api_gateway_resource.admin_showtimes_gracenote_search.id
  }
}

resource "aws_api_gateway_method" "cors_options" {
  for_each = local.cors_resources

  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = each.value
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "cors_options_integration" {
  for_each = local.cors_resources

  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = each.value
  http_method = aws_api_gateway_method.cors_options[each.key].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "cors_options_200" {
  for_each = local.cors_resources

  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = each.value
  http_method = aws_api_gateway_method.cors_options[each.key].http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "cors_options_integration_response_200" {
  for_each = local.cors_resources

  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id = each.value
  http_method = aws_api_gateway_method.cors_options[each.key].http_method
  status_code = aws_api_gateway_method_response.cors_options_200[each.key].status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# GET /clubs
resource "aws_api_gateway_method" "get_clubs" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.clubs.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_clubs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.clubs.id
  http_method             = aws_api_gateway_method.get_clubs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_clubs"].invoke_arn
}

# POST /clubs
resource "aws_api_gateway_method" "post_clubs" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.clubs.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_clubs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.clubs.id
  http_method             = aws_api_gateway_method.post_clubs.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_clubs"].invoke_arn
}

# GET /me/preferences
resource "aws_api_gateway_method" "get_me_preferences" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.me_preferences.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_me_preferences_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.me_preferences.id
  http_method             = aws_api_gateway_method.get_me_preferences.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_preferences"].invoke_arn
}

# PUT /me/preferences
resource "aws_api_gateway_method" "put_me_preferences" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.me_preferences.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "put_me_preferences_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.me_preferences.id
  http_method             = aws_api_gateway_method.put_me_preferences.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_preferences"].invoke_arn
}

# POST /clubs/{clubId}/invites
resource "aws_api_gateway_method" "post_club_invites" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.club_invites.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_club_invites_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.club_invites.id
  http_method             = aws_api_gateway_method.post_club_invites.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_invites"].invoke_arn
}

# GET /clubs/{clubId}/invites
resource "aws_api_gateway_method" "get_club_invites" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.club_invites.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_club_invites_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.club_invites.id
  http_method             = aws_api_gateway_method.get_club_invites.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_invites"].invoke_arn
}

# GET /invites/{token}
resource "aws_api_gateway_method" "get_invite" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.invite_token.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_invite_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.invite_token.id
  http_method             = aws_api_gateway_method.get_invite.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_invites"].invoke_arn
}

# POST /invites/{token}/accept
resource "aws_api_gateway_method" "post_accept_invite" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.invite_accept.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_accept_invite_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.invite_accept.id
  http_method             = aws_api_gateway_method.post_accept_invite.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_invites"].invoke_arn
}

# GET /movies/search
resource "aws_api_gateway_method" "get_movies_search" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movies_search.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_movies_search_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movies_search.id
  http_method             = aws_api_gateway_method.get_movies_search.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["movie_search"].invoke_arn
}

# GET /movies/now-playing
resource "aws_api_gateway_method" "get_movies_now_playing" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movies_now_playing.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_movies_now_playing_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movies_now_playing.id
  http_method             = aws_api_gateway_method.get_movies_now_playing.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["movie_search"].invoke_arn
}

# POST /clubs/{clubId}/movie-nights
resource "aws_api_gateway_method" "post_club_movie_nights" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.club_movie_nights.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_club_movie_nights_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.club_movie_nights.id
  http_method             = aws_api_gateway_method.post_club_movie_nights.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["create_movie_night"].invoke_arn
}

# GET /clubs/{clubId}/movie-nights/active
resource "aws_api_gateway_method" "get_active_movie_night" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.club_movie_nights_active.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_active_movie_night_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.club_movie_nights_active.id
  http_method             = aws_api_gateway_method.get_active_movie_night.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["get_active_movie_night"].invoke_arn
}

# GET /clubs/{clubId}/movie-nights/history
resource "aws_api_gateway_method" "get_movie_night_history" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.club_movie_nights_history.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_movie_night_history_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.club_movie_nights_history.id
  http_method             = aws_api_gateway_method.get_movie_night_history.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["list_history"].invoke_arn
}

# POST /movie-nights/{movieNightId}/showtimes
resource "aws_api_gateway_method" "post_movie_night_showtimes" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movie_night_showtimes.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_movie_night_showtimes_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movie_night_showtimes.id
  http_method             = aws_api_gateway_method.post_movie_night_showtimes.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["manage_showtimes"].invoke_arn
}

# PUT /movie-nights/{movieNightId}/vote
resource "aws_api_gateway_method" "put_movie_night_vote" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movie_night_vote.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "put_movie_night_vote_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movie_night_vote.id
  http_method             = aws_api_gateway_method.put_movie_night_vote.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["submit_vote"].invoke_arn
}

# GET /movie-nights/{movieNightId}/vote-results
resource "aws_api_gateway_method" "get_movie_night_vote_results" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movie_night_vote_results.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "get_movie_night_vote_results_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movie_night_vote_results.id
  http_method             = aws_api_gateway_method.get_movie_night_vote_results.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["vote_results"].invoke_arn
}

# POST /movie-nights/{movieNightId}/confirm
resource "aws_api_gateway_method" "post_movie_night_confirm" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movie_night_confirm.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_movie_night_confirm_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movie_night_confirm.id
  http_method             = aws_api_gateway_method.post_movie_night_confirm.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["confirm_showtime"].invoke_arn
}

# POST /movie-nights/{movieNightId}/complete
resource "aws_api_gateway_method" "post_movie_night_complete" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movie_night_complete.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "post_movie_night_complete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movie_night_complete.id
  http_method             = aws_api_gateway_method.post_movie_night_complete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["complete_movie_night"].invoke_arn
}

# PUT /movie-nights/{movieNightId}/rsvp
resource "aws_api_gateway_method" "put_movie_night_rsvp" {
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = aws_api_gateway_resource.movie_night_rsvp.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

resource "aws_api_gateway_integration" "put_movie_night_rsvp_integration" {
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = aws_api_gateway_resource.movie_night_rsvp.id
  http_method             = aws_api_gateway_method.put_movie_night_rsvp.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers["update_rsvp"].invoke_arn
}

resource "aws_lambda_permission" "allow_apig_app_handlers" {
  for_each = aws_lambda_function.app_handlers

  statement_id  = "AllowAPIGatewayInvoke-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.chimovieclub_api.execution_arn}/*/*"
}
