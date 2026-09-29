variable "admin_domain" {
  type = string
}

variable "admin_bucket_name" {
  type = string
}

variable "front_domain" {
  type = string
}

variable "front_bucket_name" {
  type = string
}

variable "resource_bucket_name" {
  type = string
}

# credentials.tfvars
variable "admin_api_key" {
  type = string
}

variable "admin_user" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "admin_image_uri" {
  type = string
}

variable "admin_image_tag" {
  type = string
}

variable "github_action_role_arn" {
  type = string
}

variable "lp_bucket_name" {
  description = "ランディングページを置く S3 バケット名。"
  type        = string
}

variable "lp_domain" {
  description = "ランディングページを配信するドメイン。"
  type        = string
}

variable "lp_aliases" {
  description = "ランディングページの CloudFront に設定する alternate domain name。移行が終わるまでは空。"
  type        = list(string)
  default     = []
}

variable "lp_resource_bucket_name" {
  description = "アプリが参照する画像を置く S3 バケット名。"
  type        = string
}
