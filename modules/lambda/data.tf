data "archive_file" "lambda" {
  source_file = var.source_path
  output_path = local.zip_file_name
  type        = "zip"
}