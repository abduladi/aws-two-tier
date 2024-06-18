# cloudwatch log group to send cloudtrail logs
resource "aws_cloudwatch_log_group" "s3_cloudtrail" {
  name = "s3-cloudtrail"
}

resource "aws_sns_topic" "alerts_topic" {
  name = "s3-security-alerts"
}


# Unauthorized access attempts
resource "aws_cloudwatch_log_metric_filter" "unauthorized_access_filter" {
  name           = "UnauthorizedAccess"
  log_group_name = aws_cloudwatch_log_group.s3_cloudtrail.name
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"

  metric_transformation {
    name      = "UnauthorizedAccessAttempts"
    namespace = "S3Security"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_access_alarm" {
  alarm_name                = "UnauthorizedAccessAttemptsAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "UnauthorizedAccessAttempts"
  namespace                 = "S3Security"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Alert for unauthorized access attempts"
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]
  ok_actions                = [aws_sns_topic.alerts_topic.arn]
  insufficient_data_actions = [aws_sns_topic.alerts_topic.arn]
}

# Bucket policy changes
resource "aws_cloudwatch_log_metric_filter" "bucket_policy_change_filter" {
  name           = "BucketPolicyChange"
  log_group_name = aws_cloudwatch_log_group.s3_cloudtrail.name
  pattern        = "{ ($.eventName = PutBucketPolicy) || ($.eventName = DeleteBucketPolicy) || ($.eventName = PutBucketAcl) }"

  metric_transformation {
    name      = "BucketPolicyChange"
    namespace = "S3Security"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "bucket_policy_change_alarm" {
  alarm_name                = "BucketPolicyChangeAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "BucketPolicyChange"
  namespace                 = "S3Security"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Alert for bucket policy changes"
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]
  ok_actions                = [aws_sns_topic.alerts_topic.arn]
  insufficient_data_actions = [aws_sns_topic.alerts_topic.arn]
}

# Bucket deletion
resource "aws_cloudwatch_log_metric_filter" "bucket_deletion_filter" {
  name           = "BucketDeletion"
  log_group_name = aws_cloudwatch_log_group.s3_cloudtrail.name
  pattern        = "{ ($.eventName = DeleteBucket) }"

  metric_transformation {
    name      = "BucketDeletion"
    namespace = "S3Security"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "bucket_deletion_alarm" {
  alarm_name                = "BucketDeletionAlarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "BucketDeletion"
  namespace                 = "S3Security"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "Alert for bucket deletion"
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]
  ok_actions                = [aws_sns_topic.alerts_topic.arn]
  insufficient_data_actions = [aws_sns_topic.alerts_topic.arn]
}


resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = "${var.alerts-email}"
  
}

