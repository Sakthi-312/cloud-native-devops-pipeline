module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name = local.cluster_name

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access           = true # allows the Kubernetes API endpoint to be reachable over the public internet, subject to authentication and any configured network restrictions.
  enable_cluster_creator_admin_permissions = true # grants the identity that creates the cluster administrative Kubernetes permissions.

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD" # Uses the Amazon Linux 2023 x86-64 EKS-optimized image
      instance_types = ["t3.medium"]
      min_size       = 1 # Keeps at least one worker node
      max_size       = 3 # Allows up to three worker nodes
      desired_size   = 2 # Initially targets two worker nodes
    }
  }
}
