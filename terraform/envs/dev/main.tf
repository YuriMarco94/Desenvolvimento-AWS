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

locals {
  org    = "yurim"
  app    = "aws-platform"
  env    = "dev"
  region = "us-east-1"

  tags = {
    Org         = local.org
    App         = local.app
    Env         = local.env
    ManagedBy   = "Terraform"
    CostCenter  = "interview-demo"
    Owner       = "Yuri"
    Environment = local.env
  }
}

module "network" {
  source = "../../modules/network"

  org    = local.org
  app    = local.app
  env    = local.env
  region = local.region

  vpc_cidr           = "10.10.0.0/16"
  az_count           = 2
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_s3_endpoint         = true
  enable_interface_endpoints = false
}

module "eks" {
  source = "../../modules/eks"

  org    = local.org
  app    = local.app
  env    = local.env
  region = local.region

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

############################
# Security Baseline (AWS)
############################
module "security_baseline" {
  source = "../../modules/security_baseline"

  org    = local.org
  app    = local.app
  env    = local.env
  region = local.region

  enable_securityhub           = true
  enable_securityhub_standards = false
  enable_guardduty             = true
  enable_access_analyzer       = true
  enable_inspector2            = true

  tags = local.tags
}

############################
# ECR
############################
module "ecr" {
  source = "../../modules/ecr"

  org    = local.org
  app    = local.app
  env    = local.env
  region = local.region

  repository_name     = "app"
  scan_on_push        = true
  lifecycle_keep_last = 30
  force_delete        = true

  tags = local.tags
}

############################
# GitHub OIDC Role (CI/CD)
############################
module "cicd_github" {
  source = "../../modules/cicd_github"

  org    = local.org
  app    = local.app
  env    = local.env
  region = local.region

  github_owner  = "YuriMarco94"
  github_repo   = "Desenvolvimento-AWS"
  github_branch = "develop"

  ecr_repository_arn = module.ecr.repository_arn
  eks_cluster_name   = module.eks.cluster_name

  tags = local.tags
}

############################
# Edge: CloudFront + WAF + ALB (demo OK)
############################
module "edge" {
  source = "../../modules/edge"

  org    = local.org
  app    = local.app
  env    = local.env
  region = local.region

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  # deixa vazio se não for usar domínio agora
  custom_domain = ""

  tags = local.tags
}

############################
# S3 (private)
############################
module "s3" {
  source = "../../modules/s3"

  name        = "${local.org}-${local.app}"
  environment = local.env

  bucket_name       = "${local.org}-${local.app}-${local.env}-${local.region}-apps"
  force_destroy     = true
  enable_versioning = true

  vpc_endpoint_id = try(module.network.s3_vpc_endpoint_id, null)

  tags = local.tags
}

############################
# RDS Postgres (private)
############################
module "rds" {
  source      = "../../modules/rds"
  name        = "${local.org}-${local.app}"
  environment = local.env
  region      = local.region

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  # libera do SG dos nodes do EKS
  allowed_security_group_ids = [module.eks.node_security_group_id]

  db_name           = "app"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = false

  tags = local.tags
}
