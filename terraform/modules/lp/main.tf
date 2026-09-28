##############################################################
# LP S3 Bucket
##############################################################
# バケット名はドメインと揃えない。CloudFront + OAC 構成では一致させる
# 必要が無く、移設元（Onojun アカウント）が chemist.swiswiswift.com を
# 保持しているため同名では作れない。
resource "aws_s3_bucket" "lp" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "lp" {
  bucket = aws_s3_bucket.lp.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront OAC (Origin Access Control)
# 移設元は S3 のウェブサイトホスティング（バケットを公開）だったが、
# ここでは OAC にしてバケットを非公開のままにする。
resource "aws_cloudfront_origin_access_control" "lp" {
  name                              = "${var.bucket_name}-origin-access-control"
  description                       = "Access control for CloudFront to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "lp_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.lp.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.lp.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "lp" {
  bucket = aws_s3_bucket.lp.id
  policy = data.aws_iam_policy_document.lp_bucket_policy.json
}

##############################################################
# CloudFront
##############################################################
resource "aws_cloudfront_distribution" "lp" {
  origin {
    origin_id                = aws_s3_bucket.lp.bucket_regional_domain_name
    domain_name              = aws_s3_bucket.lp.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.lp.id
  }

  aliases = [var.domain]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.domain
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.lp.bucket_regional_domain_name
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    # Managed-CachingOptimized
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  price_class = "PriceClass_200"
}
