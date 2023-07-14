##------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
##------------------------------------------------------------------------------
provider "aws" {
  region = "eu-west-1"
}

##------------------------------------------------------------------------------
## elasticsearch module call.
##------------------------------------------------------------------------------
module "elasticsearch" {
  source      = "../../"
  name        = "es"
  environment = "test"
  label_order = ["name", "environment"]
  domain_name = "clouddrove"

  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]

  #Networking
  vpc_enabled             = false
  availability_zone_count = 2
  zone_awareness_enabled  = true
  allowed_cidr_blocks     = ["51.79.69.69"]

  #ES
  elasticsearch_version = "7.8"
  instance_type         = "c5.large.elasticsearch"
  instance_count        = 2

  # Volumes
  volume_size = 30
  volume_type = "gp2"

  #DNS
  dns_enabled     = false
  es_hostname     = "es"
  kibana_hostname = "kibana"
  dns_zone_id     = false

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  #Cognito
  cognito_enabled  = false
  user_pool_id     = ""
  identity_pool_id = ""

  #logs
  log_publishing_index_enabled       = true
  log_publishing_search_enabled      = true
  log_publishing_application_enabled = true
  log_publishing_audit_enabled       = false
}
