data "aws_secretsmanager_secret" "ike_secrets" {
  arn = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}/*"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.ike_secrets.id
}