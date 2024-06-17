
# Configure CloudTrail to log s3 events
resource "aws_cloudtrail" "s3_event_log" {
  name                          = "s3-event-log"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  include_global_service_events = false
  
  # send logs to cloudwatch log group so we can configure alerts and alarms for event types
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.s3_cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn
 
  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["${aws_s3_bucket.data_bucket.arn}/"]
    }
  }
}






data "aws_iam_policy_document" "cloudtrail_s3_policy_document" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = [
      aws_s3_bucket.cloudtrail_bucket.arn
    ]

  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}




# policy to be assigned to iam role that cloudtrail will have to assume 
data "aws_iam_policy_document" "cloudtrail_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect = "Allow"
  }

  version = "2012-10-17"
}



# IAM role to be assumed by cloudtrail
resource "aws_iam_role" "cloudtrail_role" {
  name               = "cloudtrail-role"
  path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role_policy.json
}



resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = data.aws_iam_policy_document.cloudtrail_s3_policy_document.json
}



data "aws_caller_identity" "current" {}
