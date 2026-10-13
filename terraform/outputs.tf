output "terrform-cluster-name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "ecr_repositories" {
  value = { for k, v in aws_ecr_repository.app : k => v.repository_url }
}
