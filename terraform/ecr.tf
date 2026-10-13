resource "aws_ecr_repository" "app" {
  for_each             = toset(["portal-frontend", "portal-backend"])
  name                 = each.key
  force_delete         = true
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
