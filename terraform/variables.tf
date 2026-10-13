variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "portal"
}

variable "db_password" {
  type      = string
  sensitive = true
}
