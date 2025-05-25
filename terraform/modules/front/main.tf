##############################################################
# Front S3 Bucket
##############################################################
# Front S3 Bucket
resource "aws_s3_bucket" "front_s3_bucket" {
  bucket = var.front_bucket_name
}

# ブロックパブリックアクセスを無効化
resource "aws_s3_bucket_public_access_block" "front_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.front_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront OAC (Origin Access Control)
resource "aws_cloudfront_origin_access_control" "front_s3_bucket_origin_access_control" {
  name                              = "front-s3-bucket-origin-access-control"
  description                       = "Access control for CloudFront to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 バケットポリシー - OAC を許可
data "aws_iam_policy_document" "front_s3_bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.front_s3_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "front_s3_bucket_policy" {
  bucket = aws_s3_bucket.front_s3_bucket.id
  policy = data.aws_iam_policy_document.front_s3_bucket_policy_document.json
}


##############################################################
# Resource S3 Bucket
##############################################################
# Resource S3 Bucket
resource "aws_s3_bucket" "resource_s3_bucket" {
  bucket = var.resource_bucket_name
}

# ブロックパブリックアクセスを無効化
resource "aws_s3_bucket_public_access_block" "resource_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.resource_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront OAC (Origin Access Control)
resource "aws_cloudfront_origin_access_control" "resource_s3_bucket_origin_access_control" {
  name                              = "resource-s3-bucket-origin-access-control"
  description                       = "Access control for CloudFront to S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 バケットポリシー - OAC を許可
data "aws_iam_policy_document" "resource_s3_bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.resource_s3_bucket.arn}/*"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cloudfront_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "resource_s3_bucket_policy" {
  bucket = aws_s3_bucket.resource_s3_bucket.id
  policy = data.aws_iam_policy_document.resource_s3_bucket_policy_document.json
}


##############################################################
# CloudFront
##############################################################
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  // Front S3 Origin
  origin {
    origin_id   = aws_s3_bucket.front_s3_bucket.bucket_regional_domain_name
    domain_name = aws_s3_bucket.front_s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.front_s3_bucket_origin_access_control.id
  }

  // Resource S3 Origin
  origin {
    origin_id                = aws_s3_bucket.resource_s3_bucket.bucket_regional_domain_name
    domain_name              = aws_s3_bucket.resource_s3_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.resource_s3_bucket_origin_access_control.id
  }

  aliases = [
    var.front_bucket_name
  ]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.front_bucket_name
  default_root_object = "index.html"

  // Front Befavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.front_s3_bucket.bucket_regional_domain_name

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  // Resource Befavior
  ordered_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    path_pattern           = "/resource/*"
    smooth_streaming       = false
    target_origin_id       = aws_s3_bucket.resource_s3_bucket.bucket_regional_domain_name
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"

    grpc_config {
      enabled = false
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.1_2016"
    ssl_support_method             = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


##############################################################
# Route53
##############################################################
resource "aws_route53_record" "route53_record" {
  zone_id = var.zone_id
  name    = var.domain
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.cloudfront_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
  }
}
