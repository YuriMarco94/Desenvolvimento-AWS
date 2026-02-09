variable "org" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "region" { type = string }

variable "repository_name" {
  type        = string
  description = "ECR repository name (without org/app/env prefix)."
  default     = "app"
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "force_delete" {
  type    = bool
  default = true
}

variable "lifecycle_keep_last" {
  type    = number
  default = 30
}

variable "tags" {
  type    = map(string)
  default = {}
}
