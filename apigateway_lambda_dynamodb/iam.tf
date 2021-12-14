resource "aws_iam_role" "sap_labs_http_crud_tutorial_role" {
  name               = "${local.prefix}-http-crud-tutorial-role"
  assume_role_policy = data.aws_iam_policy_document.sap_labs_http_crud_tutorial_trust_policy_document.json
}

data "aws_iam_policy_document" "sap_labs_http_crud_tutorial_trust_policy_document" {
  statement {
    sid    = "AllowAlambdaToAssumeRole"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com","events.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_lambda_basic_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sap_labs_http_crud_tutorial_role.name
}

### DynamoDB Permission ###

resource "aws_iam_policy" "sap_labs_http_crud_tutorial_execution_policy" {
  name   = "${local.prefix}-http-crud-tutorial-execution-role"
  policy = data.aws_iam_policy_document.sap_labs_http_crud_tutorial_execution_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_sap_labs_http_crud_tutorial_execution_policy" {
  role       = aws_iam_role.sap_labs_http_crud_tutorial_role.name
  policy_arn = aws_iam_policy.sap_labs_http_crud_tutorial_execution_policy.arn
}

data "aws_iam_policy_document" "sap_labs_http_crud_tutorial_execution_policy_document" {
  statement {
    sid       = "AllowDynamoDB"
    effect    = "Allow"
    actions   = [       "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"]
    resources = ["*"]
  }
}
