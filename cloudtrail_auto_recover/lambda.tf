data "archive_file" "sap_labs_cloudtrail_auto_recover_zip" {
  type        = "zip"
  output_path = local.lambda_zip_path
  source_dir  = local.lambda_bundle_path
}

resource "aws_lambda_function" "sap_labs_cloudtrail_auto_recover" {
  filename      = local.lambda_zip_path
  function_name = "${local.prefix}-cloudtrails-auto-recover"
  handler       = "handler.lambda_handler"
  role          = aws_iam_role.sap_labs_cloudtrail_auto_recover_role.arn
  runtime       = "python3.7"
  timeout       = 300
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sap_labs_cloudtrail_auto_recover.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.sap_labs_trail_notification_topic.arn
}
