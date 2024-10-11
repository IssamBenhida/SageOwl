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
      days = 365
    }
  }
}