terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.1"
    }
  }
}

# ACM Certificate
resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  key_algorithm     = "RSA_2048"
}


resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_acm_certificate.acm_certificate.domain_validation_options : record.resource_record_name]
}
