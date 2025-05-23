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
# Admin Front
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
  api_lambda_function_image_uri = "392961483375.dkr.ecr.ap-northeast-1.amazonaws.com/reaction-admin:latest"
  acm_certificate_arn           = module.cloudfront_admin_certificate.certificate_arn
  domain                        = local.admin_domain
  zone_id                       = module.root_domain.zone_id
  resource_bucket_name          = "admin-storage.reaction-development.swiswiswift.com"
  resource_base_url             = "https://s3.ap-northeast-1.amazonaws.com/admin-storage.reaction-development.swiswiswift.com"
}


# ##############################################################
# # Admin API
# ##############################################################
# module "cloudfront_admin_api_certificate" {
#   source = "../../modules/cloudfront_certificate"
#   providers = {
#     aws = aws.virginia
#   }
#   zone_id     = module.root_domain.zone_id
#   domain_name = "${local.admin_api_record_name}.${local.root_domain}"
# }

# module "admin_api" {
#   source                        = "../../modules/admin_api"
#   api_lambda_function_image_uri = "392961483375.dkr.ecr.ap-northeast-1.amazonaws.com/reaction-admin:latest"
#   root_domain_name              = local.root_domain
#   api_record_name               = local.admin_api_record_name
#   api_cloudfront_certificate    = module.cloudfront_admin_api_certificate.certificate_arn
#   root_domain_zone_id           = module.root_domain.zone_id
# }


##############################################################
# Admin Database
##############################################################
module "admin_database" {
  source = "../../modules/admin_database"
}


##############################################################
# Admin Storage
##############################################################
module "admin_storage" {
  source      = "../../modules/admin_storage"
  bucket_name = "admin-storage.reaction-development.swiswiswift.com"
}


# # deprecated

# # module "web_api" {
# #   source                    = "../../modules/web_api"
# #   domain                    = local.api_domain
# #   route53_zone_id           = local.route53_zone_id
# #   acm_certificate_arn       = local.api_acm_certificate_arn
# #   application_version       = local.application_version
# #   application_bucket_name   = local.application_bucket_name
# #   resource_domain           = local.resource_domain
# #   datadog_log_forwarder_arn = local.datadog_log_forwarder_arn
# # }

# # module "datadog" {
# #   source     = "../../modules/datadog"
# #   dd_api_key = local.dd_api_key
# # }

# # module "github" {
# #   source = "../../modules/github"
# # }

# # module "lp" {
# #   source              = "../../modules/lp"
# #   bucket_name         = local.lp_bucket_name
# #   acm_certificate_arn = local.lp_acm_certificate_arn
# #   domain              = local.lp_domain
# #   zone_id             = local.route53_zone_id
# # }
