variable "environment" {
  type        = string
  description = "Environment"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}
