resource "aws_dynamodb_table" "user_votes" {
  name           = "${var.app}_user_votes"
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

resource "aws_dynamodb_table" "movie_showtime_options" {
  name           = "${var.app}_movie_showtime_options"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "movieId"     # Partition key
  range_key      = "showDate"    # Sort key

  attribute {
    name = "movieId"
    type = "S"
  }

  attribute {
    name = "showDate"
    type = "S"
  }

  tags = {
    Environment = "production"
    Project     = "MovieClub"
  }
}
