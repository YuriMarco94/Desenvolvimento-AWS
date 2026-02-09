variable "org" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "region" { type = string }

variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }

# opcional (se amanhã tu não quer domínio, deixa vazio)
variable "custom_domain" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
