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
  api_lambda_function_image_tag = "7bef9fc393bc5e1b98bc3497b85d6486509f3fbc"
  acm_certificate_arn           = module.cloudfront_admin_certificate.certificate_arn
  domain                        = local.admin_domain
  zone_id                       = module.root_domain.zone_id
  resource_bucket_name          = "resource.reaction-development.swiswiswift.com"
  resource_base_url             = "https://reaction-development.swiswiswift.com/resource/image"
}

module "admin_database" {
  source = "../../modules/admin_database"
}


