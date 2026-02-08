variable "org" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "region" { type = string }

variable "vpc_id" { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }

variable "cluster_version" {
  type    = string
  default = "1.35"
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3a.small"]
}

variable "node_desired_size" {
  type    = number
  default = 1
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 2
}

variable "enable_cluster_log_types" {
  type    = list(string)
  default = ["api", "audit", "authenticator"]
}
