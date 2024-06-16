
# Generate a random ID for the S3 bucket name
resource "random_id" "bucket_id" {
  byte_length = 12
}

# Create bucket for business data
resource "aws_s3_bucket" "data_bucket" {
  bucket = "n26-data-${random_id.bucket_id.hex}"

  # Enable versioning
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "N26 Data Bucket"
  }
}

# Create logging bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "n26-logs-${random_id.bucket_id.hex}"
  acl    = "log-delivery-write"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "Logging Bucket"
  }
}

# Enable logging for the data bucket
resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket        = aws_s3_bucket.data_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
