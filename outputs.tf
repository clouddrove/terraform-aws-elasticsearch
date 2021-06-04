# Module      : Elasticsearch
# Description : Terraform module to create Elasticsearch cluster.
output "domain_arn" {
  value       = var.zone_awareness_enabled ? join("", aws_elasticsearch_domain.default.*.arn) : join("", aws_elasticsearch_domain.single.*.arn)
  description = "ARN of the Elasticsearch domain."
}

output "domain_id" {
  value       = var.zone_awareness_enabled ? join("", aws_elasticsearch_domain.default.*.domain_id) : join("", aws_elasticsearch_domain.single.*.domain_id)
  description = "Unique identifier for the Elasticsearch domain."
}

output "domain_name" {
  value       = var.zone_awareness_enabled ? join("", aws_elasticsearch_domain.default.*.domain_name) : join("", aws_elasticsearch_domain.single.*.domain_name)
  description = "Name of the Elasticsearch domain."
}

output "endpoint" {
  value       = var.zone_awareness_enabled ? join("", aws_elasticsearch_domain.default.*.endpoint) : join("", aws_elasticsearch_domain.single.*.endpoint)
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
}

output "kibana_endpoint" {
  value       = var.zone_awareness_enabled ? join("", aws_elasticsearch_domain.default.*.kibana_endpoint) : join("", aws_elasticsearch_domain.single.*.kibana_endpoint)
  description = "Domain-specific endpoint for kibana without https scheme."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}
