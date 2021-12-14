resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "http-crud-tutorial-items"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "${local.prefix}-api"
  }
}