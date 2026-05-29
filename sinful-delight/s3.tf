resource "aws_s3_bucket" "sinful_delights_assets" {
  bucket = "${var.app}-assets" # Ensure this is globally unique

  tags = {
    Name        = "${var.app}-assets"
    Environment = "production"
    Purpose     = "Menu images and invoices"
  }
}

resource "aws_s3_bucket_versioning" "sinful_delights_assets" {
  bucket = aws_s3_bucket.sinful_delights_assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sinful_delights_assets" {
  bucket = aws_s3_bucket.sinful_delights_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "sinful_delights_assets" {
  bucket = aws_s3_bucket.sinful_delights_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Optional: Organize and expire invoice files after 1 year
resource "aws_s3_bucket_lifecycle_configuration" "sinful_delights_assets" {
  bucket = aws_s3_bucket.sinful_delights_assets.id

  rule {
    id     = "expire-old-invoices"
    status = "Enabled"

    filter {
      prefix = "invoices/"
    }

    expiration {
      days = 365
    }
  }
}
