resource "aws_ecr_repository" "poetry-image-push" {
  name                 = "poetry-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}