# # S3 bucket for CloudTrail logs
# resource "aws_s3_bucket" "cloudtrail_log_bucket" {
#   bucket = "my-cloudtrail-log-bucket"
# }

# # CloudTrail configuration
# resource "aws_cloudtrail" "trail" {
#   name                          = "my-cloudtrail"
#   s3_bucket_name                = aws_s3_bucket.cloudtrail_log_bucket.id
#   include_global_service_events = true
#   is_multi_region_trail         = true

#   event_selector {
#     read_write_type           = "All"
#     include_management_events = true

#     data_resource {
#       type   = "AWS::S3::Object"
#       values = [aws_s3_bucket.main_bucket.arn]
#     }
#   }
# }
