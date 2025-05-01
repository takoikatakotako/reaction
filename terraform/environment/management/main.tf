terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.1"
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
    # local.production_account_id
  ]
}

# module "batch_repository" {
#   source = "../../modules/repository"
#   name   = "charalarm-batch"
#   allow_pull_account_ids = [
#     local.development_account_id,
#     local.staging_account_id,
#     local.production_account_id
#   ]
# }

# module "worker_repository" {
#   source = "../../modules/repository"
#   name   = "charalarm-worker"
#   allow_pull_account_ids = [
#     local.development_account_id,
#     local.staging_account_id,
#     local.production_account_id
#   ]
# }

module "github" {
  source = "../../modules/github"
}
