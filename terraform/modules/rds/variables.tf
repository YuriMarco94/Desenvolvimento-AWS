variable "name" {
  type        = string
  description = "Base name for resources"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/hml/prod)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for DB subnet group"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Security groups allowed to reach the DB (e.g., EKS node SG)"
  default     = []
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "app"
}

variable "engine_version" {
  type        = string
  description = "PostgreSQL engine version"
  default     = "15.7"
}

variable "instance_class" {
  type        = string
  description = "DB instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GiB"
  default     = 20
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ"
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention in days"
  default     = 7
}

variable "deletion_protection" {
  type        = bool
  description = "Deletion protection"
  default     = false
}

variable "publicly_accessible" {
  type        = bool
  description = "Public access"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
