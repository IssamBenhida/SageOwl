resource "aws_opensearch_domain" "main" {
  domain_name    = var.domain_name
  engine_version = var.engine_version

  cluster_config {
    instance_type          = var.instance_type
    instance_count         = var.instance_count
    zone_awareness_enabled = var.availability_zones > 1
    dynamic "zone_awareness_config" {
      for_each = var.availability_zones > 1 ? [1] : []
      content {
        availability_zone_count = var.availability_zones
      }
    }
  }

  dynamic "ebs_options" {
    for_each = length(var.ebs_options) > 0 ? [var.ebs_options] : []
    content {
      ebs_enabled = try(var.ebs_options.value.ebs_enabled, true)
      volume_type = try(var.ebs_options.value.volume_type, "gp3")
      volume_size = try(var.ebs_options.value.volume_size, 10)
      throughput = try(var.ebs_options.value.throughput, null)
      iops = try(var.ebs_options.value.iops, 0)
    }
  }

  timeouts {
    create = "3m"
  }

  tags = var.tags
}
