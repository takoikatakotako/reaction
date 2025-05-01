# API Lambda Function
resource "aws_lambda_function" "api_lambda_function" {
  function_name = "reaction-api"
  timeout       = 30
  role          = aws_iam_role.api_lambda_function_role.arn
  image_uri     = var.api_lambda_function_image_uri
  package_type  = "Image"
  architectures = ["arm64"]

  environment {
    variables = {
      "REACTION_AWS_PROFILE" = "",
      "RESOURCE_BASE_URL"     = "https://resource.charalarm-development.swiswiswift.com"
      "RESOURCE_BUCKET_NAME" = "admin-storage.reaction-development.swiswiswift.com"
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

# CloudFront Distribution
resource "aws_cloudfront_distribution" "api_cloudfront_distribution" {
  enabled         = true
  is_ipv6_enabled = true

  aliases = [
    "${var.api_record_name}.${var.root_domain_name}",
  ]

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

  default_cache_behavior {
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

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.api_cloudfront_certificate
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

# Record
resource "aws_route53_record" "api_record" {
  zone_id = var.root_domain_zone_id
  name    = var.api_record_name
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_cloudfront_distribution.api_cloudfront_distribution.domain_name
    zone_id                = local.cloudfront_zone_id
  }
}
