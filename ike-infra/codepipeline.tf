resource "aws_codepipeline" "ike_codepipeline" {
  name     = var.codepipeline
  role_arn = aws_iam_role.ike_codepipeline_role.arn

  artifact_store {
    location = var.bucket_name
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.ike_kms.id 
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["sourceOutput"]

      configuration = {
        RepositoryName = "ike-fitness-repo"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["sourceOutput"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.ike_codebuild_project.name
      }
      output_artifacts = ["ike-artifacts"]
    }
  }

}