variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "terraform-portal"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "github_repo" {
  type    = string
  default = "Sakthi-312/cloud-native-devops-pipeline"
}
