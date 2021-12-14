resource "aws_cloudtrail" "sap_labs_cloudtrails" {
  name                          = "${local.prefix}-cloudtrails"
  s3_bucket_name                = aws_s3_bucket.sap_labs_cloud_trail_log.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  sns_topic_name                = aws_sns_topic.sap_labs_trail_notification_topic.name
}

