variable "bucket_name" {
  description = "ランディングページを置く S3 バケット名。"
  type        = string
}

variable "resource_bucket_name" {
  description = "アプリが参照する画像を置く S3 バケット名。LP とは分ける。"
  type        = string
}

variable "domain" {
  description = "配信するドメイン。証明書と CloudFront の comment に使う。"
  type        = string
}

variable "aliases" {
  description = <<-EOT
    CloudFront の alternate domain name。

    同じ名前を 2 つの distribution に登録できないため、移行が終わるまでは
    空にしておく。associate-alias で所有権を移したあとに domain を入れる。
  EOT
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "us-east-1 で発行した ACM 証明書の ARN。"
  type        = string
}
