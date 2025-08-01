terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.1"
    }
  }

  backend "s3" {
    bucket  = "reaction.terraform.state"
    key     = "development/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "reaction-management"
  }
}

provider "aws" {
  profile = "reaction-development"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "virginia"
  profile = "reaction-development"
  region  = "us-east-1"
}


##############################################################
# Common
##############################################################
module "root_domain" {
  source = "../../modules/domain"
  name   = local.root_domain
}


##############################################################
# Front
##############################################################
module "cloudfront_front_certificate" {
  source = "../../modules/cloudfront_certificate"
  providers = {
    aws = aws.virginia
  }
  zone_id     = module.root_domain.zone_id
  domain_name = local.front_domain
}

module "front" {
  source               = "../../modules/front"
  resource_bucket_name = local.resource_bucket_name
  front_bucket_name    = local.front_bucket_name
  acm_certificate_arn  = module.cloudfront_front_certificate.certificate_arn
  zone_id              = module.root_domain.zone_id
  domain               = local.front_domain
}


##############################################################
# Admin
##############################################################
module "cloudfront_admin_certificate" {
  source = "../../modules/cloudfront_certificate"
  providers = {
    aws = aws.virginia
  }
  zone_id     = module.root_domain.zone_id
  domain_name = local.admin_domain
}

module "admin" {
  source                        = "../../modules/admin"
  bucket_name                   = local.admin_bucket_name
  api_lambda_function_image_uri = "392961483375.dkr.ecr.ap-northeast-1.amazonaws.com/reaction-admin"
  api_lambda_function_image_tag = "18bbbbcf602c4e51f705d3bade358b09e34b750e"
  acm_certificate_arn           = module.cloudfront_admin_certificate.certificate_arn
  domain                        = local.admin_domain
  zone_id                       = module.root_domain.zone_id
  resource_bucket_name          = "resource.reaction-development.swiswiswift.com"
  resource_base_url             = "https://reaction-development.swiswiswift.com/resource/image"
  api_key                       = var.admin_api_key
  front_distribution_id         = module.front.distribution_id
  admin_user                    = var.admin_user
  admin_password                = var.admin_password
}

module "admin_database" {
  source = "../../modules/admin_database"
}


##############################################################
# GitHub
##############################################################
module "github" {
  source                 = "../../modules/github_for_app"
  github_action_role_arn = "arn:aws:iam::392961483375:role/reaction-github-action-role"
}
