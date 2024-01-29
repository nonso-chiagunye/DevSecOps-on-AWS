resource "aws_codecommit_repository" "ike_repo" {
  repository_name = var.codecommit_repo
  description     = "Repository for Ike Fitness"
}