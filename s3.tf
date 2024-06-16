
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
    # only SSE-S3 is supported for buckets that will be targets for access logs
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}




# Enable logging for the data bucket
resource "aws_s3_bucket_logging" "bucket_logging" {
  bucket        = aws_s3_bucket.data_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}






resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({

    Version: "2012-10-17",
    Statement: [
        {
            Sid: "S3ServerAccessLogsPolicy",
            Effect: "Allow",
            Principal: {
                Service: "logging.s3.amazonaws.com"
            },
            Action: [
                "s3:PutObject"
            ],
            Resource: "${aws_s3_bucket.log_bucket.id}/log*",
            Condition: {
                ArnLike: {
                    aws:SourceArn: "${aws_s3_bucket.data_bucket.id}"
                }
            }
        }
    ]


  })



}






    
					