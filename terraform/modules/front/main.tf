##############################################################
# S3 Bucket
##############################################################
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
}

# resource "aws_s3_bucket_policy" "s3_bucket_policy" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   policy = data.aws_iam_policy_document.iam_policy_document.json

#   depends_on = [
#     aws_s3_bucket_public_access_block.bucket_public_access_block,
#   ]
# }

# resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
#   bucket                  = aws_s3_bucket.s3_bucket.id
#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# data "aws_iam_policy_document" "iam_policy_document" {
#   statement {
#     sid = "AddPerm"
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


##############################################################
# CloudFront
##############################################################
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = "S3-${var.bucket_name}"
  }

      origin {
          connection_attempts = 3
          connection_timeout  = 10
          domain_name         = "resource.reaction-development.swiswiswift.com.s3.ap-northeast-1.amazonaws.com"
          origin_id           = "resource.reaction-development.swiswiswift.com.s3.ap-northeast-1.amazonaws.com"
          origin_access_control_id = "EN6I4Y8NIM5NZ"
     }


  aliases = [
    var.bucket_name
  ]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.bucket_name
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

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

      ordered_cache_behavior {
          allowed_methods        = [
              "GET",
              "HEAD",
            ]
          cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" 
          cached_methods         = [
              "GET",
              "HEAD",
            ] 
          compress               = true 
         default_ttl            = 0
          max_ttl                = 0 
          min_ttl                = 0
          path_pattern           = "/resource/*" 
          smooth_streaming       = false 
          target_origin_id       = "resource.reaction-development.swiswiswift.com.s3.ap-northeast-1.amazonaws.com"
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
