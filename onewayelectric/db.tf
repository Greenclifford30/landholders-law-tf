resource "aws_dynamodb_table" "service_requests" {
  name           = "${var.app}-service-requests"
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "PK"
  range_key      = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  # Optional GSI for querying by status
  global_secondary_index {
    name               = "StatusIndex"
    hash_key           = "status"
    range_key          = "requestedAt"
    projection_type    = "ALL"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "requestedAt"
    type = "S"
  }

  tags = {
    Environment = "production"
    Project     = "OneWayElectric"
  }
}
