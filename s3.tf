
# Generate a random ID for the S3 bucket name
resource "random_id" "bucket_id" {
  byte_length = 12
}

# Create bucket for business data
resource "aws_s3_bucket" "data_bucket" {
  bucket = "n26-data-${random_id.bucket_id.hex}"


  tags = {
    Name = "N26 Data Bucket"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "data_bucket_versioning" {
  bucket = aws_s3_bucket.data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "data_bucket_encryption" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}


# set ownership to bucket owner preferred so that act log delivery write can be assigned
resource "aws_s3_bucket_ownership_controls" "data_bucket_ownership" {
  bucket = aws_s3_bucket.data_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "data_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.data_bucket_ownership]

  bucket = aws_s3_bucket.data_bucket.id
  acl    = "private"
}






# Create server access logging bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "n26-logs-${random_id.bucket_id.hex}"

  tags = {
    Name = "Logging Bucket"
  }
}



resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket_encryption" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}


# set ownership to bucket owner preferred so that acl can be assigned
resource "aws_s3_bucket_ownership_controls" "log_bucket_acl_ownership" {
  bucket = aws_s3_bucket.log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.log_bucket_acl_ownership]
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
}



# Enable logging for the data bucket
resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket        = aws_s3_bucket.data_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
