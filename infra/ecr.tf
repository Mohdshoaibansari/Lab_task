resource "aws_ecr_repository" "eks-repo" {
  name                 = "eks-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}