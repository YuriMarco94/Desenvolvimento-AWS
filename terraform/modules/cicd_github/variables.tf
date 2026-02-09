variable "org" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "region" { type = string }

variable "github_owner" { type = string }   # ex: YuriMarco94
variable "github_repo"  { type = string }   # ex: Desenvolvimento-AWS
variable "github_branch" {
  type    = string
  default = "develop"
}

variable "ecr_repository_arn" { type = string }
variable "eks_cluster_name"   { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
