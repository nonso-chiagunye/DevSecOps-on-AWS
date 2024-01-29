resource "aws_eks_cluster" "ike_eks_cluster" {
  name     = var.eks_cluster
  role_arn = aws_iam_role.ike_eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.ike_private_subnet01.id, aws_subnet.ike_private_subnet02.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,  
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]

  tags = {
    Name = var.eks_cluster
  }
}

resource "aws_eks_node_group" "ike_nodes" {
  cluster_name    = aws_eks_cluster.ike_eks_cluster.name
  node_group_name = var.eks_node
  node_role_arn   = aws_iam_role.ike_eks_node_role.arn
  instance_types = ["c5.large"]
  disk_size = "300"
  subnet_ids      = [aws_subnet.ike_private_subnet01.id, aws_subnet.ike_private_subnet02.id]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}