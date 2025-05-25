# resource "aws_s3_bucket" "s3_bucket" {
#   bucket = var.bucket_name
# }

# # ブロックパブリックアクセスを無効化
# resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
#   bucket                  = aws_s3_bucket.s3_bucket.id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# # CloudFront OAC (Origin Access Control)
# resource "aws_cloudfront_origin_access_control" "s3_origin_access_control" {
#   name                              = "resource-bucket-oac"
#   description                       = "Resource Bucket OAC"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }



# # S3 バケットポリシー - OAC を許可
# data "aws_iam_policy_document" "s3_bucket_policy_policy_document" {
#   statement {
#     actions = ["s3:GetObject"]
#     resources = [
#       "${aws_s3_bucket.s3_bucket.arn}/*"
#     ]

#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }

#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.cdn.arn]
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "policy" {
#   bucket = aws_s3_bucket.static_site.id
#   policy = data.aws_iam_policy_document.s3_policy.json
# }






# resource "aws_s3_bucket_policy" "s3_bucket_policy" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   policy = data.aws_iam_policy_document.iam_policy_document.json

#   depends_on = [
#     aws_s3_bucket_public_access_block.bucket_public_access_block,
#   ]
# }


# data "aws_iam_policy_document" "iam_policy_document" {
#   statement {
#     sid = "PublicReadGetObject"
#     actions = [
#       "s3:GetObject"
#     ]
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#     resources = [
#       "arn:aws:s3:::${var.bucket_name}/*"
#     ]
#   }
# }

# resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors_configuration" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["GET", "POST", "PUT"]
#     allowed_origins = ["*"]
#     expose_headers  = []
#     max_age_seconds = 3000
#   }
#   }

// たぶん不要
# resource "aws_s3_bucket_website_configuration" "s3_bucket_website_configuration" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   index_document {
#     suffix = "index.html"
#   }
# }
