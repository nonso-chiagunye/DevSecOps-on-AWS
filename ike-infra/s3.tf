

resource "aws_s3_bucket" "ike_artifact_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "ike_artifact_ownership_control" {
  bucket = aws_s3_bucket.ike_artifact_bucket.id
  rule {
    # object_ownership = "BucketOwnerPreferred"
    object_ownership = "ObjectWriter"
  }
}

# resource "aws_s3_bucket_acl" "ike_artifact_acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.ike_artifact_ownership_control]

#   bucket = aws_s3_bucket.ike_artifact_bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_versioning" "ike_artifact_versioning" {
  bucket = aws_s3_bucket.ike_artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ike_bucket_encryption" {
  bucket = aws_s3_bucket.ike_artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ike_kms.key_id
      sse_algorithm     = "aws:kms"
    }
  }
}