terraform {
  required_version = "~> 1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }

  backend "s3" {
    bucket  = "reaction.terraform.state"
    key     = "management/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "reaction-management"
  }
}

provider "aws" {
  profile = "reaction-management"
  region  = "ap-northeast-1"
}



//////////////////////////////////////////
// Repository
//////////////////////////////////////////
module "admin_repository" {
  source = "../../modules/repository"
  name   = "reaction-admin"
  allow_pull_account_ids = [
    local.development_account_id,
    local.production_account_id,
  ]
}

module "github" {
  source = "../../modules/github_for_management"
}
