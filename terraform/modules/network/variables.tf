variable "org" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "region" { type = string }

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

# Para modo econômico: 1 NAT compartilhado (mais barato) vs NAT por AZ (mais HA)
variable "single_nat_gateway" {
  type    = bool
  default = true
}

# Endpoints
variable "enable_s3_endpoint" {
  type    = bool
  default = true
}

variable "enable_interface_endpoints" {
  type    = bool
  default = false
}

variable "interface_endpoints" {
  type = list(string)
  default = [
    "ecr.api",
    "ecr.dkr",
    "logs",
    "sts",
    "secretsmanager"
  ]
}
