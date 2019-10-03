# Managed By : CloudDrove
# Description : This Script is used to create Elasticsearch.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and #              tags for resources. You can use terraform-labels to implement a strict #              naming convention.
module "labels" {
  source = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.12.0"

  name        = var.name
  application = var.application
  environment = var.environment
  label_order = var.label_order
}

#Module      : Iam Service Linked Role
#Description : Terraform module to create Iam Service Linked Role resource on AWS.
resource "aws_iam_service_linked_role" "default" {
  count            = var.enabled && var.enable_iam_service_linked_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "AWSServiceRoleForAmazonElasticsearchService Service-Linked Role"
}

#Module      : Iam Role
#Description : Terraform module to create Iam Role resource on AWS.
resource "aws_iam_role" "default" {
  count              = var.enabled ? 1 : 0
  name               = format("%s-role",module.labels.id)
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  description        = "IAM Role to assume to access the Elasticsearch cluster"
  tags               = module.labels.tags
}

#Module      : Iam Policy
#Description : Terraform module to create Iam Role Policy resource on AWS.
data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Allow"
  }
}

#Module      : Elasticsearch
#Description : Terraform module to create Elasticsearch resource on AWS.
resource "aws_elasticsearch_domain" "default" {
  count                 = var.enabled && var.zone_awareness_enabled ? 1 : 0
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  advanced_options = var.advanced_options

  ebs_options {
    ebs_enabled = var.volume_size > 0 ? true : false
    volume_size = var.volume_size
    volume_type = var.volume_type
    iops        = var.iops
  }

  encrypt_at_rest {
    enabled    = false
    kms_key_id = var.kms_key_id
  }

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled   = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  node_to_node_encryption {
    enabled = var.encryption_enabled
  }

  vpc_options {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  log_publishing_options {
    enabled                  = var.log_publishing_index_enabled
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_index_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_search_enabled
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_search_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_application_enabled
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_application_cloudwatch_log_group_arn
  }

  tags = module.labels.tags

  depends_on = [aws_iam_service_linked_role.default]
}

#Module      : Elasticsearch
#Description : Terraform module to create Elasticsearch resource on AWS.
resource "aws_elasticsearch_domain" "single" {
  count                 = var.enabled && var.zone_awareness_enabled == false ? 1 : 0
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  advanced_options = var.advanced_options

  ebs_options {
    ebs_enabled = var.volume_size > 0 ? true : false
    volume_size = var.volume_size
    volume_type = var.volume_type
    iops        = var.iops
  }

  encrypt_at_rest {
    enabled    = false
    kms_key_id = var.kms_key_id
  }

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
  }

  node_to_node_encryption {
    enabled = var.encryption_enabled
  }

  vpc_options {
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  log_publishing_options {
    enabled                  = var.log_publishing_index_enabled
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_index_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_search_enabled
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_search_cloudwatch_log_group_arn
  }

  log_publishing_options {
    enabled                  = var.log_publishing_application_enabled
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = var.log_publishing_application_cloudwatch_log_group_arn
  }

  tags = module.labels.tags

  depends_on = [aws_iam_service_linked_role.default]
}

#Module      : Elasticsearch Role Policy
#Description : Terraform module to create Elasticsearch resource on AWS.
data "aws_iam_policy_document" "default" {
  count = var.enabled ? 1 : 0

  statement {
    actions = distinct(compact(var.iam_actions))

    resources = [
      var.zone_awareness_enabled ? join("", aws_elasticsearch_domain.default.*.arn) : join("", aws_elasticsearch_domain.single.*.arn),
      var.zone_awareness_enabled ? format("%s/*", join("", aws_elasticsearch_domain.default.*.arn)) : format("%s/*", join("", aws_elasticsearch_domain.single.*.arn))
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

#Module      : Elasticsearch Policy
#Description : Terraform module to create Elasticsearch policy resource on AWS.
resource "aws_elasticsearch_domain_policy" "default" {
  count           = var.enabled ? 1 : 0
  domain_name     = var.domain_name
  access_policies = join("", data.aws_iam_policy_document.default.*.json)
}
