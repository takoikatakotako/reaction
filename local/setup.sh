#!/bin/sh
# DynamoDB のテーブルと S3 のバケットを作る。
# LocalStack の /etc/localstack/init/ready.d 相当を、明示的な init コンテナで行う。
set -e

create_table() {
  name="$1"
  if aws dynamodb describe-table --endpoint-url "$DYNAMODB_ENDPOINT" --table-name "$name" >/dev/null 2>&1; then
    echo "table already exists: $name"
    return
  fi
  aws dynamodb create-table \
    --endpoint-url "$DYNAMODB_ENDPOINT" \
    --table-name "$name" \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    >/dev/null
  echo "created table: $name"
}

create_table reactions
create_table questions
create_table notices

# S3 のバケットを作る。s3mock は認証もバケットポリシーも検証しないため、
# put-bucket-policy は不要。
BUCKET=resource.reaction-local.swiswiswift.com
if aws s3api head-bucket --endpoint-url "$S3_ENDPOINT" --bucket "$BUCKET" >/dev/null 2>&1; then
  echo "bucket already exists: $BUCKET"
else
  aws s3api create-bucket --endpoint-url "$S3_ENDPOINT" --bucket "$BUCKET" >/dev/null
  echo "created bucket: $BUCKET"
fi

echo "setup completed"
