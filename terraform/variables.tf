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

variable "github_owner" {
  type    = string
  default = "Sakthi-312"
}

variable "github_owner_id" {
  type    = string
  default = "208243505"
}

variable "github_repo_name" {
  type    = string
  default = "cloud-native-devops-pipeline"
}

variable "github_repo_id" {
  type    = string
  default = "1418925582"
}
