resource "aws_api_gateway_resource" "club_proposals" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_id.id
  path_part   = "movie-proposals"
}
resource "aws_api_gateway_resource" "club_proposal_id" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_proposals.id
  path_part   = "{proposalId}"
}
resource "aws_api_gateway_resource" "club_proposal_endorsement" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_proposal_id.id
  path_part   = "endorsement"
}
resource "aws_api_gateway_resource" "club_proposal_schedule" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.club_proposal_id.id
  path_part   = "schedule"
}

locals {
  collaboration_routes = {
    proposal_list      = { resource_id = aws_api_gateway_resource.club_proposals.id, method = "GET", handler = "manage_movie_proposals" }
    proposal_create    = { resource_id = aws_api_gateway_resource.club_proposals.id, method = "POST", handler = "manage_movie_proposals" }
    proposal_update    = { resource_id = aws_api_gateway_resource.club_proposal_id.id, method = "PATCH", handler = "manage_movie_proposals" }
    proposal_endorse   = { resource_id = aws_api_gateway_resource.club_proposal_endorsement.id, method = "PUT", handler = "manage_movie_proposals" }
    proposal_unendorse = { resource_id = aws_api_gateway_resource.club_proposal_endorsement.id, method = "DELETE", handler = "manage_movie_proposals" }
    proposal_schedule  = { resource_id = aws_api_gateway_resource.club_proposal_schedule.id, method = "POST", handler = "manage_movie_proposals" }
    night_list         = { resource_id = aws_api_gateway_resource.club_movie_nights.id, method = "GET", handler = "list_movie_nights" }
    personal_agenda    = { resource_id = aws_api_gateway_resource.me_movie_nights.id, method = "GET", handler = "list_movie_nights" }
    night_edit         = { resource_id = aws_api_gateway_resource.movie_night_id.id, method = "PATCH", handler = "list_movie_nights" }
    plan_acknowledge   = { resource_id = aws_api_gateway_resource.plan_acknowledgement_me.id, method = "PUT", handler = "list_movie_nights" }
    night_detail       = { resource_id = aws_api_gateway_resource.movie_night_id.id, method = "GET", handler = "list_movie_nights" }
  }
}
resource "aws_api_gateway_method" "collaboration" {
  for_each      = local.collaboration_routes
  rest_api_id   = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id   = each.value.resource_id
  http_method   = each.value.method
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}
resource "aws_api_gateway_integration" "collaboration" {
  for_each                = local.collaboration_routes
  rest_api_id             = aws_api_gateway_rest_api.chimovieclub_api.id
  resource_id             = each.value.resource_id
  http_method             = aws_api_gateway_method.collaboration[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app_handlers[each.value.handler].invoke_arn
}

resource "aws_api_gateway_resource" "me_movie_nights" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.me.id
  path_part   = "movie-nights"
}
resource "aws_api_gateway_resource" "plan_acknowledgement" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.movie_night_id.id
  path_part   = "plan-acknowledgement"
}
resource "aws_api_gateway_resource" "plan_acknowledgement_me" {
  rest_api_id = aws_api_gateway_rest_api.chimovieclub_api.id
  parent_id   = aws_api_gateway_resource.plan_acknowledgement.id
  path_part   = "me"
}
