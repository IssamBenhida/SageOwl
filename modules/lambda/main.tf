# tfsec:ignore:aws-lambda-enable-tracing
resource "aws_lambda_function" "main" {
  function_name = var.function_name
  description   = var.description
  role          = var.lambda_role
  filename      = "index.zip"
  runtime       = var.runtime
  handler       = var.handler

  source_code_hash = data.archive_file.lambda.output_base64sha256

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size == null ? [] : [true]
    content {
      size = var.ephemeral_storage_size
    }
  }

  dynamic "tracing_config" {
    for_each = length(var.tracing_config) == 0 ? [] : [true]
    content {
      mode  = try(var.tracing_config.mode, "PassThrough")
    }
  }

  tags = var.tags
}