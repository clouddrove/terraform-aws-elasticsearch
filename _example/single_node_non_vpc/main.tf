##------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
##------------------------------------------------------------------------------
provider "aws" {
  region = local.region
}
locals {
  region      = "eu-west-1"
  name        = "es"
  environment = "test"
}
##------------------------------------------------------------------------------
## elasticsearch module call.
##------------------------------------------------------------------------------
module "elasticsearch" {
  source      = "../../"
  name        = local.name
  environment = local.environment

  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]

  #Networking
  vpc_enabled         = false
  allowed_cidr_blocks = ["51.79.69.69"]

  #Es
  elasticsearch_version = "7.8"
  instance_type         = "c5.large.elasticsearch"
  instance_count        = 1

  #Volume
  volume_size = 30
  volume_type = "gp2"

  #Logs
  log_publishing_application_enabled = true

  #Cognito
  cognito_enabled  = false
  user_pool_id     = ""
  identity_pool_id = ""

  #DNS
  kibana_hostname = "kibana"
  dns_zone_id     = "Z1XJD7SSBKXLC1"
  dns_enabled     = false
  es_hostname     = "es"
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  enforce_https       = true
  tls_security_policy = "Policy-Min-TLS-1-0-2019-07"

}
