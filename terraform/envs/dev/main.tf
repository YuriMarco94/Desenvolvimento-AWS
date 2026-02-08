terraform {
  backend "s3" {
    bucket         = "yurim-aws-platform-us-east-1-tfstate-0dc5ad"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "yurim-aws-platform-us-east-1-tflock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Org        = "yurim"
      App        = "aws-platform"
      Env        = "dev"
      ManagedBy  = "Terraform"
      CostCenter = "interview-demo"
      Owner      = "Yuri"
    }
  }
}

module "network" {
  source = "../../modules/network"

  org    = "yurim"
  app    = "aws-platform"
  env    = "dev"
  region = "us-east-1"

  vpc_cidr                 = "10.10.0.0/16"
  az_count                 = 2
  enable_nat_gateway       = true
  single_nat_gateway       = true

  enable_s3_endpoint       = true
  enable_interface_endpoints = false
}
