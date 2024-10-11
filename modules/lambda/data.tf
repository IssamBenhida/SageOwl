data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda" {
  source_file = var.source_path
  output_path = "index.zip"
  type        = "zip"
}