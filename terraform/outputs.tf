output "cluster_name" {
  value = module.eks.cluster_name
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "ecr_repositories" {
  value = { for k, v in aws_ecr_repository.app : k => v.repository_url }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "lb_controller_role_arn" {
  value = module.lb_controller_irsa.iam_role_arn
}
