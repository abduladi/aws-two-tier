
# Configure CloudTrail to log s3 events
resource "aws_cloudtrail" "s3_event_log" {
  name                          = "s3-event-log"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = [aws_s3_bucket.data_bucket.arn]
    }
  }
}
