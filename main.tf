# Managed By : CloudDrove
# Description : This Script is used to create Elasticsearch.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : Label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.
module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  enabled     = var.enabled
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  attributes  = var.attributes
  label_order = var.label_order
}

resource "aws_cloudwatch_log_group" "cloudwatch" {
  count             = var.enabled && var.enable_logs ? 1 : 0
  name              = module.labels.id
  tags              = module.labels.tags
  retention_in_days = var.retention_in_days
  kms_key_id        = var.cloudwatch_kms_key_id

}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_policy" {
  count           = var.enabled && var.enable_logs ? 1 : 0
  policy_name     = module.labels.id
  policy_document = data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json
}

#Module      : Iam Service Linked Role
#Description : Terraform module to create Iam Service Linked Role resource on AWS.

resource "aws_iam_service_linked_role" "default" {
  count            = var.enabled && var.enable_iam_service_linked_role ? 1 : 0
  aws_service_name = "opensearchservice.amazonaws.com"
  description      = "AWSServiceRoleForAmazonElasticsearchService Service-Linked Role"
  tags             = module.labels.tags
}

#Module      : Iam Role
#Description : Terraform module to create Iam Role resource on AWS.
resource "aws_iam_role" "default" {
  count              = var.enabled ? 1 : 0
  name               = format("%s-role", module.labels.id)
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
data "aws_iam_policy_document" "elasticsearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = ["arn:aws:logs:*"]
    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "cognito_es_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "cognito-idp:DescribeUserPool",
      "cognito-idp:CreateUserPoolClient",
      "cognito-idp:DeleteUserPoolClient",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:AdminInitiateAuth",
      "cognito-idp:AdminUserGlobalSignOut",
      "cognito-idp:ListUserPoolClients",
      "cognito-identity:DescribeIdentityPool",
      "cognito-identity:UpdateIdentityPool",
      "cognito-identity:SetIdentityPoolRoles",
      "cognito-identity:GetIdentityPoolRoles"
    ]
    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "es_assume_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

module "cognito-role" {
  source  = "clouddrove/iam-role/aws"
  version = "0.15.0"

  name        = format("%s-cognito-role", module.labels.id)
  environment = var.environment
  label_order = ["name"]
  enabled     = var.cognito_enabled

  assume_role_policy = data.aws_iam_policy_document.es_assume_policy.json

  policy_enabled = true
  policy         = data.aws_iam_policy_document.cognito_es_policy.json
}

#Module      : Elasticsearch
#Description : Terraform module to create Elasticsearch resource on AWS.
#tfsec:ignore:aws-elastic-search-use-secure-tls-policy
resource "aws_elasticsearch_domain" "default" {
  count                 = var.enabled ? 1 : 0
  domain_name           = var.domain_name != "" ? var.domain_name : module.labels.id
  elasticsearch_version = var.elasticsearch_version

  advanced_options = var.advanced_options

  ebs_options {
    ebs_enabled = var.volume_size > 0 ? true : false
    volume_size = var.volume_size
    volume_type = var.volume_type
    iops        = var.iops
  }

  auto_tune_options {
    desired_state = var.auto_tune_desired_state
  }

  cognito_options {
    enabled          = var.cognito_enabled
    user_pool_id     = var.user_pool_id
    identity_pool_id = var.identity_pool_id
    role_arn         = module.cognito-role.arn
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.kms_key_id
  }

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = var.dedicated_master_type
    zone_awareness_enabled   = var.zone_awareness_enabled
    warm_enabled             = var.warm_enabled
    warm_count               = var.warm_enabled ? var.warm_count : null
    warm_type                = var.warm_enabled ? var.warm_type : null

    dynamic "zone_awareness_config" {
      for_each = var.availability_zone_count > 1 ? [true] : []
      content {
        availability_zone_count = var.availability_zone_count
      }
    }
  }

  node_to_node_encryption {
    enabled = var.encryption_enabled
  }

  dynamic "vpc_options" {
    for_each = var.vpc_enabled ? [true] : []

    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  log_publishing_options {
    enabled                  = var.log_publishing_index_enabled
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = format("%s:*", join("", aws_cloudwatch_log_group.cloudwatch.*.arn))
  }

  log_publishing_options {
    enabled                  = var.log_publishing_search_enabled
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = format("%s:*", join("", aws_cloudwatch_log_group.cloudwatch.*.arn))
  }

  log_publishing_options {
    enabled                  = var.log_publishing_application_enabled
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = format("%s:*", join("", aws_cloudwatch_log_group.cloudwatch.*.arn))
  }

  log_publishing_options {
    enabled                  = var.log_publishing_audit_enabled
    log_type                 = "AUDIT_LOGS"
    cloudwatch_log_group_arn = format("%s:*", join("", aws_cloudwatch_log_group.cloudwatch.*.arn))
  }

  domain_endpoint_options {
    enforce_https                   = var.enforce_https
    tls_security_policy             = var.tls_security_policy
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
  }

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = var.advanced_security_options_internal_user_database_enabled
    master_user_options {
      master_user_arn      = var.advanced_security_options_master_user_arn
      master_user_name     = var.advanced_security_options_master_user_name
      master_user_password = var.advanced_security_options_master_user_password
    }
  }
  tags = module.labels.tags

  depends_on = [aws_iam_service_linked_role.default]
}

#Module      : Elasticsearch Role Policy
#Description : Terraform module to create Elasticsearch resource on AWS.
data "aws_iam_policy_document" "default" {
  count = var.enabled ? 1 : 0

  dynamic "statement" {
    for_each = length(var.allowed_cidr_blocks) > 0 && !var.vpc_enabled ? [true] : []
    content {
      effect = "Allow"

      actions = distinct(compact(var.iam_actions))

      resources = [
        join("", aws_elasticsearch_domain.default.*.arn),
        "${join("", aws_elasticsearch_domain.default.*.arn)}/*"
      ]

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      condition {
        test     = "IpAddress"
        values   = var.allowed_cidr_blocks
        variable = "aws:SourceIp"
      }
    }
  }
}
data "aws_iam_policy_document" "vpc" {
  count = var.enabled ? 1 : 0

  statement {
    actions = distinct(compact(var.iam_actions))
    effect  = "Allow"

    resources = [
      join("", aws_elasticsearch_domain.default.*.arn),
      format("%s/*", join("", aws_elasticsearch_domain.default.*.arn))
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
  domain_name     = var.domain_name != "" ? var.domain_name : module.labels.id
  access_policies = var.vpc_enabled ? join("", data.aws_iam_policy_document.vpc.*.json) : join("", data.aws_iam_policy_document.default.*.json)
}

#Module      : ROUTE53
#Description : Provides a Route53 record resource.
module "es_dns" {
  source         = "clouddrove/route53-record/aws"
  version        = "0.15.0"
  record_enabled = var.dns_enabled
  zone_id        = var.dns_zone_id
  name           = var.es_hostname
  type           = var.type
  ttl            = var.ttl
  values         = join("", aws_elasticsearch_domain.default.*.endpoint)
}
#Module      : ROUTE53
#Description : Provides a Route53 record resource.
module "kibana_dns" {
  source         = "clouddrove/route53-record/aws"
  version        = "0.15.0"
  record_enabled = var.dns_enabled
  zone_id        = var.dns_zone_id
  name           = var.kibana_hostname
  type           = var.type
  ttl            = var.ttl
  values         = join("", aws_elasticsearch_domain.default.*.endpoint)
}
