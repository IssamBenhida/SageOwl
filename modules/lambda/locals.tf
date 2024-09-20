locals {
  file_name_with_extension = var.source_path
  file_name                = split(".", local.file_name_with_extension)[0]
  zip_file_name            = "${local.file_name}.zip"
}
