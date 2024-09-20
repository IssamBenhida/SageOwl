resource "aws_lambda_function" "main" {
  function_name = var.function_name
  description   = var.description
  filename      = local.zip_file_name
  role          = var.lambda_role
  runtime       = var.runtime
  handler       = var.handler

  source_code_hash = data.archive_file.lambda.output_base64sha256
}