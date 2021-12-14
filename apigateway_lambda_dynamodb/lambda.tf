data "archive_file" "sap_labs_http_crud_tutorial_zip" {
  type        = "zip"
  output_path = local.lambda_zip_path
  source_dir  = local.lambda_bundle_path
}

resource "aws_lambda_function" "sap_labs_http_crud_tutorial" {
  filename      = local.lambda_zip_path
  function_name = "${local.prefix}-http-crud-tutorial-function"
  handler       = "index.handler"
  role          = aws_iam_role.sap_labs_http_crud_tutorial_role.arn
  runtime       = "nodejs14.x"
  timeout       = 300
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sap_labs_http_crud_tutorial.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
