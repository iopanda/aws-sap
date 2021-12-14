resource "aws_iam_role" "sap_labs_auto_stop_ec2_role" {
  name               = "${local.prefix}-auto-stop-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.sap_labs_auto_stop_ec2_trust_policy_document.json
}

data "aws_iam_policy_document" "sap_labs_auto_stop_ec2_trust_policy_document" {
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
  role       = aws_iam_role.sap_labs_auto_stop_ec2_role.name
}

### EC2 Permission ###

resource "aws_iam_policy" "sap_labs_auto_stop_ec2_execution_policy" {
  name   = "${local.prefix}-auto-stop-ec2-execution-role"
  policy = data.aws_iam_policy_document.sap_labs_auto_stop_ec2_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attach_lambda_ec2_access_policy" {
  role       = aws_iam_role.sap_labs_auto_stop_ec2_role.name
  policy_arn = aws_iam_policy.sap_labs_auto_stop_ec2_execution_policy.arn
}

data "aws_iam_policy_document" "sap_labs_auto_stop_ec2_role_policy_document" {
  statement {
    sid       = "AllowStopEC2"
    effect    = "Allow"
    actions   = ["ec2:List*", "ec2:Read*", "ec2:Describe*", "ec2:StopInstances"]
    resources = ["*"]
  }
}
