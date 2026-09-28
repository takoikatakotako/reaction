variable "bucket_name" {
  description = "ランディングページを置く S3 バケット名。"
  type        = string
}

variable "domain" {
  description = "配信するドメイン。CloudFront の alias と証明書に使う。"
  type        = string
}

variable "acm_certificate_arn" {
  description = "us-east-1 で発行した ACM 証明書の ARN。"
  type        = string
}
