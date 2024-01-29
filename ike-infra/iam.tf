data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ike_codebuild_role" {
  name = var.codebuild_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ike_codebuild_policy" {
  name   = var.codebuild_policy
  role   = aws_iam_role.ike_codebuild_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "eks:*",
        Resource = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster}",
      },
      {
        Effect = "Allow",
        Action = "ecr:*",
        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repo}",
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "*",
      },
      {
  Effect   = "Allow",
  Action   = [
    "codebuild:StartBuild",
    "codebuild:BatchGetBuilds",
    "codebuild:StopBuild",
  ],
  Resource = "*",
},
{
  Effect   = "Allow",
  Action   = "kms:*",
  Resource = "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*",
},
{
  Effect   = "Allow",
  Action   = "secretsmanager:*",
  Resource = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}",
},
{
  Effect   = "Allow",
  Action   = "s3:*",
  Resource = "arn:aws:s3:::${var.bucket_name}/*",
}
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ike_codebuild_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
  role       = aws_iam_role.ike_codebuild_role.name
}

resource "aws_iam_role_policy_attachment" "ike_codebuild_policy_attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.ike_codebuild_role.name
}

resource "aws_iam_role_policy_attachment" "ike_codebuild_policy_attachment3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.ike_codebuild_role.name
}

resource "aws_iam_role" "ike_eks_cluster_role" {
  name = var.cluster_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ike_eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.ike_eks_cluster_role.name
}

resource "aws_iam_role" "ike_eks_node_role" {
  name = var.node_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "ike_eks_node_policy" {
  name   = var.node_policy
  role   = aws_iam_role.ike_eks_node_role.name

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repo}"
        },
         {
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}"
        }
    ]
})
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ike_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ike_eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ike_eks_node_role.name
}