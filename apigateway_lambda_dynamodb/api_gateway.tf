resource "aws_apigatewayv2_api" "lambda" {
  name          = "http-crud-tutorial-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id
  name        = "http-crud-tutorial-api-stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id
  integration_uri    = aws_lambda_function.sap_labs_http_crud_tutorial.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}