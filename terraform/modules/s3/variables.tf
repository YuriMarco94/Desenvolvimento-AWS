variable "name" {
  type        = string
  description = "Base name"
}

variable "environment" {
  type        = string
  description = "Environment (dev/hml/prod)"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "force_destroy" {
  type        = bool
  description = "Allow destroying bucket with objects (dev only)"
  default     = true
}

variable "enable_versioning" {
  type        = bool
  description = "Enable versioning"
  default     = true
}

variable "vpc_endpoint_id" {
  type        = string
  description = "Optional: Restrict bucket access to this VPC Endpoint ID (Gateway endpoint for S3)"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
