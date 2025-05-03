#!/bin/bash
set -x

# reactions table
awslocal s3api create-bucket \
  --bucket resource.reaction-local.swiswiswift.com \
  --region ap-northeast-1 \
  --create-bucket-configuration LocationConstraint=ap-northeast-1

awslocal s3 website s3://resource.reaction-local.swiswiswift.com/ \
  --index-document index.html \
  --error-document error.html


awslocal s3api put-bucket-policy --bucket resource.reaction-local.swiswiswift.com --policy '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::resource.reaction-local.swiswiswift.com/*"
    }
  ]
}'

set +x


# aws s3 cp README.md s3://resource.reaction-local.swiswiswift.com/   --endpoint-url http://localhost:4566

