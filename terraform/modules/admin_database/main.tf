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

resource "aws_dynamodb_table" "questions_table" {
  name           = "questions"
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

resource "aws_dynamodb_table" "notices_table" {
  name           = "notices"
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


##############################################################
# Outputs
##############################################################
output "table_names" {
  value = [
    aws_dynamodb_table.reactions_table.name,
    aws_dynamodb_table.questions_table.name,
    aws_dynamodb_table.notices_table.name,
  ]
}
