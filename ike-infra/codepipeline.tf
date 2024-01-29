resource "aws_iam_role" "ike_codepipeline_role" {
  name = var.codepipeline_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ike_codepipeline_policy" {
  name   = var.codepipeline_policy
  role   = aws_iam_role.ike_codepipeline_role.name

  policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [ 
                        "ec2.amazonaws.com",
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetRepository",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },

        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },

        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },

        {
      "Effect": "Allow",
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt" 
      ],
      "Resource": "*"
    }
    ],
    "Version": "2012-10-17"
})
}

resource "aws_iam_role_policy_attachment" "ike_codepipeline_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
  role       = aws_iam_role.ike_codepipeline_role.name
}

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