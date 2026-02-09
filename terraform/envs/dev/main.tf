terraform {
  backend "s3" {
    bucket         = "yurim-aws-platform-us-east-1-tfstate-3f67c8"
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

  vpc_cidr           = "10.10.0.0/16"
  az_count           = 2
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_s3_endpoint         = true
  enable_interface_endpoints = false
}

module "eks" {
  source = "../../modules/eks"

  org    = "yurim"
  app    = "aws-platform"
  env    = "dev"
  region = "us-east-1"

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids

  cluster_version = "1.35"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  node_instance_types = ["t3a.large"]
  node_desired_size   = 8
  node_min_size       = 8
  node_max_size       = 8
}

output "vpc_id" { value = module.network.vpc_id }
output "public_subnet_ids" { value = module.network.public_subnet_ids }
output "private_subnet_ids" { value = module.network.private_subnet_ids }
output "eks_cluster_name" { value = module.eks.cluster_name }

