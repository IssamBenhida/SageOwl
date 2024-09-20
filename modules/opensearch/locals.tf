locals {
  free_tier = var.enable_free_tier && var.availability_zones > 1
}

resource "null_resource" "validate_availability_zones" {
  count = local.free_tier ? 1 : 0
  provisioner "local-exec" {
    command = "echo 'Not allowed under AWS free tier.'"
  }
}
