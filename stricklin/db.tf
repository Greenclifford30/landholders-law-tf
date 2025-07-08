resource "aws_dynamodb_table" "attendees" {
  name           = "Reunion_Attendees"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # Global Secondary Index for registrationCode lookup
  attribute {
    name = "registrationCode"
    type = "S"
  }

  global_secondary_index {
    name            = "GSI1"
    hash_key        = "registrationCode"
    projection_type = "ALL"
  }

  # Optional: enable point-in-time recovery (backups)
  point_in_time_recovery {
    enabled = true
  }

  # Optional: enable TTL for records
  # ttl {
  #   attribute_name = "expiresAt"
  #   enabled        = true
  # }

  tags = {
    Environment = "Prd"
    Project     = "FamilyReunion2025"
  }
}
