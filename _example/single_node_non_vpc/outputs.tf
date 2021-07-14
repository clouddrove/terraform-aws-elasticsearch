output "arn" {
  value       = module.elasticsearch.domain_arn
  description = "ARN of the Elasticsearch domain."
}

output "tags" {
  value       = module.elasticsearch.tags
  description = "A mapping of tags to assign to the resource."
}
