resource "aws_kinesis_firehose_delivery_stream" "main" {
  destination = var.destination
  name        = var.name

  dynamic "opensearch_configuration" {
    for_each = var.destination == "opensearch" ? [1] : []
    content {
      domain_arn     = var.opensearch_domain_arn
      role_arn       = var.firehose_role_arn
      index_name     = var.opensearch_index_name
      type_name      = var.opensearch_type_name
      s3_backup_mode = var.s3_backup_mode

      s3_configuration {
        bucket_arn = var.s3_backup_bucket_arn
        role_arn   = var.firehose_role_arn
      }

      dynamic "processing_configuration" {
        for_each = var.enable_processing ? [1] : []
        content {
          enabled = true
          processors {
            type = "Lambda"
            parameters {
              parameter_name  = "LambdaArn"
              parameter_value = var.processing_lambda_arn
            }
            parameters {
              parameter_name  = "RoleArn"
              parameter_value = var.processing_lambda_role
            }
          }
        }
      }
    }
  }

  tags = var.tags
}