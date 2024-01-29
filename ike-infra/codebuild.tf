resource "aws_codebuild_project" "ike_codebuild_project" {
  name = var.codebuild_project
  service_role  = aws_iam_role.ike_codebuild_role.arn
  source {
    type = "CODECOMMIT"
    location = aws_codecommit_repository.ike_repo.clone_url_http
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name  = "SONAR_ORGANIZATION_KEY"
      value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["SONAR_ORGANIZATION_KEY"]
    }
    environment_variable {
      name  = "SONAR_PROJECT_KEY"
      value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["SONAR_PROJECT_KEY"]
    }
    environment_variable {
      name  = "SNYK_TOKEN"
      value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["SNYK_TOKEN"]
    }
    environment_variable {
      name  = "SONAR_TOKEN"
      value = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["SONAR_TOKEN"]
    }
  }
   artifacts {
    type = "S3"
    location = var.bucket_name
  }
}
