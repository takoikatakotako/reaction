terraform {
  required_version = "~> 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.8.1"
    }
  }

  backend "s3" {
    bucket  = "reaction.terraform.state"
    key     = "production/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "reaction-management"
  }
}

provider "aws" {
  profile = "reaction-production"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "virginia"
  profile = "reaction-production"
  region  = "us-east-1"
}


##############################################################
# Front
##############################################################
module "cloudfront_front_certificate" {
  source = "../../modules/cloudfront_certificate"
  providers = {
    aws = aws.virginia
  }
  domain_name = var.front_domain
}

module "front" {
  source               = "../../modules/front"
  resource_bucket_name = var.resource_bucket_name
  front_bucket_name    = var.front_bucket_name
  acm_certificate_arn  = module.cloudfront_front_certificate.certificate_arn
  domain               = var.front_domain
}

##############################################################
# Admin
##############################################################
module "cloudfront_admin_certificate" {
  source = "../../modules/cloudfront_certificate"
  providers = {
    aws = aws.virginia
  }
  domain_name = var.admin_domain
}

module "admin" {
  source                        = "../../modules/admin"
  bucket_name                   = var.admin_bucket_name
  api_lambda_function_image_uri = var.admin_image_uri
  api_lambda_function_image_tag = var.admin_image_tag
  acm_certificate_arn           = module.cloudfront_admin_certificate.certificate_arn
  domain                        = var.admin_domain
  resource_bucket_name          = var.resource_bucket_name
  resource_base_url             = "https://${var.front_domain}/resource/image"
  api_key                       = var.admin_api_key
  front_distribution_id         = module.front.distribution_id
  admin_user                    = var.admin_user
  admin_password                = var.admin_password
  api_log_retention_in_days     = 30
}

module "admin_database" {
  source = "../../modules/admin_database"
}

##############################################################
# GitHub
##############################################################
module "github" {
  source                 = "../../modules/github_for_app"
  github_action_role_arn = var.github_action_role_arn
}

##############################################################
# Monitoring
##############################################################
module "monitoring" {
  source                           = "../../modules/monitoring"
  environment                      = "production"
  lambda_function_name             = module.admin.api_lambda_function_name
  lambda_log_group_name            = module.admin.api_lambda_log_group_name
  dynamodb_table_names             = module.admin_database.table_names
  slack_webhook_ssm_parameter_name = "/reaction/production/slack-alert-webhook-url"
}
