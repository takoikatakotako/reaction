#!/bin/bash
set -x

# reactions table
awslocal dynamodb create-table \
    --table-name reactions \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --region ap-northeast-1

set +x
