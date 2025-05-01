# DynamoDB
resource "aws_dynamodb_table" "reactions_table" {
  name           = "reactions"
  hash_key       = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  stream_enabled = false

  attribute {
    name = "id"
    type = "S"
  }
}
