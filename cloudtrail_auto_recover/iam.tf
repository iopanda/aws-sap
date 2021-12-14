resource "aws_iam_role" "sap_labs_cloudtrail_auto_recover_role" {
  name               = "${local.prefix}-cloudtrails-auto-recover"
  assume_role_policy = data.aws_iam_policy_document.sap_labs_cloudtrail_auto_recover_trust_policy_document.json
}

data "aws_iam_policy_document" "sap_labs_cloudtrail_auto_recover_trust_policy_document" {
  statement {
    sid    = "AllowAlambdaToAssumeRole"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_lambda_basic_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sap_labs_cloudtrail_auto_recover_role.name
}

resource "aws_iam_role_policy_attachment" "attach_lambda_s3_full_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.sap_labs_cloudtrail_auto_recover_role.name
}

resource "aws_iam_role_policy_attachment" "attach_lambda_vpc_full_access_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.sap_labs_cloudtrail_auto_recover_role.name
}