variable "org" { type = string }
variable "app" { type = string }
variable "env" { type = string }
variable "region" { type = string }

variable "enable_securityhub" {
  type    = bool
  default = true
}

variable "enable_securityhub_standards" {
  type    = bool
  default = false
}

variable "enable_guardduty" {
  type    = bool
  default = true
}

variable "enable_access_analyzer" {
  type    = bool
  default = true
}

variable "enable_inspector2" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
