resource "aws_lambda_function" "main" {
  function_name = var.function_name
  description   = var.description
  role          = var.lambda_role
  filename      = "index.zip"
  runtime       = var.runtime
  handler       = var.handler

  source_code_hash = data.archive_file.lambda.output_base64sha256
}