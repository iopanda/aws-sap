resource "aws_cloudwatch_event_rule" "sap_labs_auto_stop_ec2_scheduler" {
  name = "auto-stop-ec2-scheduler"
  description = "Stop running EC2 at 00:00 am every day"
  schedule_expression = "cron(10 16 * * ? *)"
}

resource "aws_cloudwatch_event_target" "sap_labs_auto_stop_ec2" {
  rule      = aws_cloudwatch_event_rule.sap_labs_auto_stop_ec2_scheduler.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.sap_labs_auto_stop_ec2.arn
}
