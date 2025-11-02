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
