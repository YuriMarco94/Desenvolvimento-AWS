terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Org         = "yurim"
      App         = "aws-platform"
      ManagedBy   = "Terraform"
      CostCenter  = "interview-demo"
      Owner       = "Yuri"
    }
  }
}

# -----------------------------
# Naming base
# -----------------------------
locals {
  org    = "yurim"
  app    = "aws-platform"
  region = "us-east-1"

  # backend resources (shared)
  backend_name = "${local.org}-${local.app}-${local.region}"

  # tfstate bucket: precisa ser globalmente único.
  # Sufixo randômico evita conflito com nomes já existentes.
}

resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  tfstate_bucket = "${local.backend_name}-tfstate-${random_id.suffix.hex}"
  tflock_table   = "${local.backend_name}-tflock"
  kms_alias      = "alias/${local.backend_name}-tfstate"
}

# -----------------------------
# KMS (encrypt tfstate)
# -----------------------------
resource "aws_kms_key" "tfstate" {
  description             = "KMS key for Terraform remote state encryption (${local.backend_name})"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "tfstate" {
  name          = local.kms_alias
  target_key_id = aws_kms_key.tfstate.key_id
}

# -----------------------------
# S3 Bucket (tfstate)
# -----------------------------
resource "aws_s3_bucket" "tfstate" {
  bucket = local.tfstate_bucket
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.tfstate.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Opcional, mas bem sênior: trava o bucket contra deleção acidental
resource "aws_s3_bucket_ownership_controls" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# -----------------------------
# DynamoDB (state lock)
# -----------------------------
resource "aws_dynamodb_table" "tflock" {
  name         = local.tflock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------
# Outputs (pra você copiar pro backend dos envs)
# -----------------------------
output "tfstate_bucket_name" {
  value       = aws_s3_bucket.tfstate.bucket
  description = "S3 bucket name for Terraform remote state."
}

output "tflock_table_name" {
  value       = aws_dynamodb_table.tflock.name
  description = "DynamoDB table name for Terraform state locking."
}

output "tfstate_kms_key_arn" {
  value       = aws_kms_key.tfstate.arn
  description = "KMS key ARN used to encrypt Terraform remote state."
}
