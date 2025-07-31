resource "aws_ecr_repository" "ECR_Repo" {
  name = var.ECR_repository_name
  #   image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = var.tag_name_ecr
    Environment = "test"
  }
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.ECR_Repo.repository_url
  description = "The URL of the ECR repository"
}

output "ecr_repository_arn" {
  value       = aws_ecr_repository.ECR_Repo.arn
  description = "The ARN of the ECR repository"
}
