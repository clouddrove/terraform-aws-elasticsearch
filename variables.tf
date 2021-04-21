#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://registry.terraform.io/modules/clouddrove/elasticsearch/aws/0.14.0"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

# Module      : Elasticsearch Module
# Description : Terraform Elasticsearch Module variables.
variable "enable_iam_service_linked_role" {
  type        = bool
  default     = false
  description = "Whether to enabled service linked with role."
}

variable "iam_role_arns" {
  type        = list(string)
  default     = []
  description = "List of IAM role ARNs to permit access to the Elasticsearch domain."
  sensitive   = true
}

variable "iam_authorizing_role_arns" {
  type        = list(string)
  default     = []
  description = "List of IAM role ARNs to permit to assume the Elasticsearch user role."
  sensitive   = true
}

variable "iam_actions" {
  type        = list(string)
  default     = []
  description = "List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "cognito_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent enable cognito."
}

variable "elasticsearch_version" {
  type        = string
  default     = "6.5"
  description = "Version of Elasticsearch to deploy."
}

variable "instance_type" {
  type        = string
  default     = "t2.small.elasticsearch"
  description = "Elasticsearch instance type for data nodes in the cluster."
}

variable "user_pool_id" {
  type        = string
  default     = ""
  description = "ID of the Cognito User Pool to use."
}

variable "identity_pool_id" {
  type        = string
  default     = ""
  description = "ID of the Cognito Identity Pool to use."
}

variable "instance_count" {
  type        = number
  default     = 4
  description = "Number of data nodes in the cluster."
}

variable "zone_awareness_enabled" {
  type        = bool
  default     = false
  description = "Enable zone awareness for Elasticsearch cluster."
}

variable "public_enabled" {
  type        = bool
  default     = false
  description = "Enable Elasticsearch cluster is public or not."
}

variable "availability_zone_count" {
  type        = number
  default     = 2
  description = "Number of Availability Zones for the domain to use."
}

variable "volume_size" {
  type        = number
  default     = 0
  description = "EBS volumes for data storage in GB."
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "Storage type of EBS volumes."
}

variable "iops" {
  type        = number
  default     = 0
  description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type."
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable encryption at rest."
}

variable "kms_key_id" {
  type        = string
  default     = ""
  description = "The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key."
  sensitive   = true
}

variable "log_publishing_index_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not."
}

variable "log_publishing_search_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for SEARCH_SLOW_LOGS is enabled or not."
}

variable "log_publishing_application_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether log publishing option for ES_APPLICATION_LOGS is enabled or not."
}

variable "log_publishing_index_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for INDEX_SLOW_LOGS needs to be published."
  sensitive   = true
}

variable "log_publishing_search_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for SEARCH_SLOW_LOGS needs to be published."
  sensitive   = true
}

variable "log_publishing_application_cloudwatch_log_group_arn" {
  type        = string
  default     = ""
  description = "ARN of the CloudWatch log group to which log for ES_APPLICATION_LOGS needs to be published."
  sensitive   = true
}

variable "automated_snapshot_start_hour" {
  type        = number
  default     = 0
  description = "Hour at which automated snapshots are taken, in UTC."
}

variable "dedicated_master_enabled" {
  type        = bool
  default     = false
  description = "Indicates whether dedicated master nodes are enabled for the cluster."
}

variable "dedicated_master_count" {
  type        = number
  default     = 0
  description = "Number of dedicated master nodes in the cluster."
}

variable "dedicated_master_type" {
  type        = string
  default     = "t2.small.elasticsearch"
  description = "Instance type of the dedicated master nodes in the cluster."
}

variable "advanced_options" {
  type        = map(string)
  default     = {}
  description = "Key-value string pairs to specify advanced configuration options."
}

variable "encryption_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable node-to-node encryption."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet IDs."
  sensitive   = true
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Security Group IDs."
  sensitive   = true
}

variable "domain_name" {
  type        = string
  default     = ""
  description = "Domain name."
}
variable "enable_logs" {
  type        = bool
  default     = true
  description = "enable logs"
}

variable "dns_enabled" {
  type        = bool
  default     = false
  description = "Flag to control the dns_enable."
}

variable "dns_zone_id" {
  type        = string
  default     = ""
  description = "Route53 DNS Zone ID to add hostname records for Elasticsearch domain and Kibana."
  sensitive   = true
}

variable "es_hostname" {
  type        = string
  default     = ""
  description = "The Host name of elasticserch."
  sensitive   = true
}

variable "kibana_hostname" {
  type        = string
  default     = ""
  description = "The Host name of kibana."
  sensitive   = true
}

variable "type" {
  type        = string
  default     = "CNAME"
  description = "Type of DNS records to create."
}

variable "ttl" {
  type        = string
  default     = "300"
  description = "The TTL of the record to add to the DNS zone to complete certificate validation."
}

variable "enforce_https" {
  type        = bool
  default     = false
  description = "Whether or not to require HTTPS."
}

variable "tls_security_policy" {
  default     = "Policy-Min-TLS-1-0-2019-07"
  description = "The name of the TLS security policy that needs to be applied to the HTTPS endpoint."
}