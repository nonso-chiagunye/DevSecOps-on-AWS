

resource "aws_kms_key" "ike_kms" {
  description             = "Ike KMS key 1"
  deletion_window_in_days = 7
}