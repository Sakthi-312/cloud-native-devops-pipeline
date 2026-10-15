resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "gha_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Sakthi-312@208243505/cloud-native-devops-pipeline@1418925582:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "gha" {
  name               = "${var.project}-github-actions"
  assume_role_policy = data.aws_iam_policy_document.gha_trust.json
}

data "aws_iam_policy_document" "gha_permissions" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
    ]
    resources = [for r in aws_ecr_repository.app : r.arn]
  }
  statement {
    actions   = ["eks:DescribeCluster"]
    resources = [module.eks.cluster_arn]
  }
}

resource "aws_iam_role_policy" "gha" {
  name   = "ecr-push-eks-describe"
  role   = aws_iam_role.gha.id
  policy = data.aws_iam_policy_document.gha_permissions.json
}

# Lets the role run kubectl, but only inside the "portal" namespace
resource "aws_eks_access_entry" "gha" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.gha.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "gha" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.gha.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

  access_scope {
    type       = "namespace"
    namespaces = ["portal"]
  }

  depends_on = [aws_eks_access_entry.gha]
}
