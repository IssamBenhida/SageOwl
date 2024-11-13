# tfsec:ignore:aws-s3-enable-versioning
# tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "backup" {
  bucket = "sageowl-backup"

  tags = {
    department  = "security"
    function    = "backup"
    environment = "dev"
  }

  depends_on = [module.opensearch]
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {

  bucket = aws_s3_bucket.backup.id

  rule {
    id     = "immediate-to-glacier"
    status = "Enabled"

    transition {
      days          = 0
      storage_class = "GLACIER"
    }

    expiration {
      days = 1825
    }

    noncurrent_version_expiration {
      noncurrent_days = 365
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backup" {

  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


resource "aws_kms_key" "main" {
  description         = "This key is used to encrypt bucket objects"
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backup" {

  bucket = aws_s3_bucket.backup.id

  rule {
    apply_server_side_encryption_by_default {

      kms_master_key_id = aws_kms_key.main.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
