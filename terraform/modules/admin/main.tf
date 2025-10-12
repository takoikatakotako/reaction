##############################################################
# S3 Bucket
##############################################################
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.iam_policy_document.json

  depends_on = [
    aws_s3_bucket_public_access_block.bucket_public_access_block,
  ]
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    sid = "AddPerm"
    actions = [
      "s3:GetObject"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}


##############################################################
# API Lambda Function
##############################################################
resource "aws_lambda_function" "api_lambda_function" {
  function_name = "reaction-api"
  timeout       = 30
  role          = aws_iam_role.api_lambda_function_role.arn
  image_uri     = "${var.api_lambda_function_image_uri}:${var.api_lambda_function_image_tag}"
  package_type  = "Image"
  architectures = ["arm64"]

  environment {
    variables = {
      "REACTION_AWS_PROFILE"  = "",
      "API_KEY"               = var.api_key
      "RESOURCE_BUCKET_NAME"  = var.resource_bucket_name
      "RESOURCE_BASE_URL"     = var.resource_base_url
      "FRONT_DISTRIBUTION_ID" = var.front_distribution_id
    }
  }
}

resource "aws_lambda_function_url" "api_lambda_function_url" {
  function_name      = aws_lambda_function.api_lambda_function.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id           = "AllowCloudFrontServicePrincipal"
  function_url_auth_type = "NONE"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.api_lambda_function.function_name
  principal              = "cloudfront.amazonaws.com"
}


##############################################################
# Basic Auth Function
##############################################################
resource "aws_cloudfront_function" "basic_auth_function" {
  name    = "admin-basic-auth-function"
  publish = true
  runtime = "cloudfront-js-2.0"
  code = templatefile("${path.module}/basic-auth-function.js", {
    admin_user     = var.admin_user,
    admin_password = var.admin_password,
  })
}


##############################################################
# CloudFront
##############################################################
resource "aws_cloudfront_distribution" "charalarm_cloudfront_distribution" {
  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = "S3-${var.bucket_name}"
  }

  origin {
    domain_name = "${aws_lambda_function_url.api_lambda_function_url.url_id}.lambda-url.ap-northeast-1.on.aws"
    origin_id   = "${aws_lambda_function_url.api_lambda_function_url.url_id}.lambda-url.ap-northeast-1.on.aws"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  aliases = [
    var.bucket_name
  ]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.bucket_name
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth_function.arn
    }

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

  ordered_cache_behavior {
    path_pattern             = "/api/*"
    cache_policy_id          = local.cache_policy_id
    compress                 = true
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "${aws_lambda_function_url.api_lambda_function_url.url_id}.lambda-url.ap-northeast-1.on.aws"
    origin_request_policy_id = local.origin_request_policy_id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
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
