resource "aws_dynamodb_table" "admin_selections" {
  name           = "${var.app}-AdminSelections"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }

  tags = {
    Environment = "production"
    Project     = "ChiMovieClub"
    ManagedBy   = "Terraform"
  }
}

resource "aws_dynamodb_table" "user_votes" {
  name           = "${var.app}-UserVotes"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PK"

  attribute {
    name = "PK"
    type = "S"
  }

  tags = {
    Environment = "production"
    Project     = "ChiMovieClub"
    ManagedBy   = "Terraform"
  }
}