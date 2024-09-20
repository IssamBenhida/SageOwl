output "domain_endpoint" {
  description = "Opensearch domain endpoint."
  value       = aws_opensearch_domain.main.domain_name
}

output "domain_arn" {
  description = "Opensearch domain arn."
  value       = aws_opensearch_domain.main.arn
}

output "availability_zones" {
  description = "OpenSearch cluster availability zones count."
  value       = var.availability_zones
}
