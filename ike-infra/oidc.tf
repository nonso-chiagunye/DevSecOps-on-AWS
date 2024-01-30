resource "aws_eks_addon" "ike_csi_driver" {
  cluster_name             = aws_eks_cluster.ike_eks_cluster.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ike_ebs_csi_driver.arn
}

data "tls_certificate" "ike_cert" {
  url = aws_eks_cluster.ike_eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "ike_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.ike_cert.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.ike_eks_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "ike_csi_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.ike_oidc.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.ike_oidc.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "ike_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.ike_csi_policy.json
  name               = "eks-ebs-csi-driver"
}

resource "aws_iam_role_policy_attachment" "ike_ebs_csi_driver" {
  role       = aws_iam_role.ike_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}