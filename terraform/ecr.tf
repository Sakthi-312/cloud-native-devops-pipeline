resource "aws_ecr_repository" "app" {
  for_each             = toset(["terraform-portal-frontend", "terraform-portal-backend"])
  name                 = each.key  # each.key supplies the name for each repository.
  force_delete         = true      # allows Terraform to delete a repository even when it contains images.
  image_tag_mutability = "MUTABLE" # permits an existing image tag to be overwritten.

  image_scanning_configuration {
    scan_on_push = true
  }
}
