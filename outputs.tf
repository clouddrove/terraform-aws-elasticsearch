# Module      : Elasticsearch
# Description : Terraform module to create Elasticsearch cluster.
output "domain_arn" {
  value       = join("", aws_elasticsearch_domain.default.*.arn)
  description = "ARN of the Elasticsearch domain."
}

output "tags" {
  value       = module.labels.tags
  description = "A mapping of tags to assign to the resource."
}