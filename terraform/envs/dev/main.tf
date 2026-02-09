terraform {
  backend "s3" {
    bucket         = "yurim-aws-platform-us-east-1-tfstate-3f67c8"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "yurim-aws-platform-us-east-1-tflock"
    encrypt        = true
  }
}

############################################
# Locals (para usar local.* nos módulos)
############################################
locals {
  name        = "yurim-aws-platform"
  environment = "dev"
  region      = "us-east-1"

  tags = {
    Org        = "yurim"
    App        = "aws-platform"
    Env        = "dev"
    ManagedBy  = "Terraform"
    CostCenter = "interview-demo"
    Owner      = "Yuri"
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = local.tags
  }
}

############################################
# Network
############################################
module "network" {
  source = "../../modules/network"

  org    = "yurim"
  app    = "aws-platform"
  env    = local.environment
  region = local.region

  vpc_cidr           = "10.10.0.0/16"
  az_count           = 2
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_s3_endpoint         = true
  enable_interface_endpoints = false
}

############################################
# EKS
############################################
module "eks" {
  source = "../../modules/eks"

  org    = "yurim"
  app    = "aws-platform"
  env    = local.environment
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
# Security Baseline
############################
module "security_baseline" {
  source      = "../../modules/security_baseline"
  environment = local.environment

  tags = local.tags
}

############################
# S3 (private)
############################
module "s3" {
  source      = "../../modules/s3"
  name        = local.name
  environment = local.environment

  bucket_name       = "${local.name}-${local.environment}-${local.region}-apps"
  force_destroy     = true
  enable_versioning = true

  # Se existir output do VPCE do S3 no module.network, restringe via policy
  vpc_endpoint_id = try(module.network.s3_vpc_endpoint_id, null)

  tags = local.tags
}

############################
# RDS Postgres (private)
############################
module "rds" {
  source      = "../../modules/rds"
  name        = local.name
  environment = local.environment
  region      = local.region

  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  # ✅ Libera acesso ao Postgres SOMENTE dos nodes do EKS
  allowed_security_group_ids = [module.eks.node_security_group_id]

  db_name           = "app"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  multi_az          = false

  tags = local.tags

  # Opcional, mas deixa explícito
  depends_on = [module.eks]
}

############################################
# Outputs
############################################
output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}
