data "archive_file" "sap_labs_auto_stop_ec2_zip" {
  type        = "zip"
  output_path = local.lambda_zip_path
  source_dir  = local.lambda_bundle_path
}

resource "aws_lambda_function" "sap_labs_auto_stop_ec2" {
  filename      = local.lambda_zip_path
  function_name = "${local.prefix}-auto-stop-ec2"
  handler       = "handler.lambda_handler"
  role          = aws_iam_role.sap_labs_auto_stop_ec2_role.arn
  runtime       = "python3.7"
  timeout       = 300
}

resource "aws_lambda_permission" "with_cloudwatch_rule" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sap_labs_auto_stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sap_labs_auto_stop_ec2_scheduler.arn
}
