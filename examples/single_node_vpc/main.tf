##------------------------------------------------------------------------------
## Provider block added, Use the Amazon Web Services (AWS) provider to interact with the many resources supported by AWS.
##------------------------------------------------------------------------------
provider "aws" {
  region = local.region
}
locals {
  region                = "eu-west-1"
  name                  = "es"
  environment           = "test"
  vpc_cidr_block        = module.vpc.vpc_cidr_block
  additional_cidr_block = "172.16.0.0/16"
}
##------------------------------------------------------------------------------
## A VPC is a virtual network that closely resembles a traditional network that you'd operate in your own data center.
##------------------------------------------------------------------------------
module "vpc" {
  source  = "clouddrove/vpc/aws"
  version = "2.0.5"

  name        = "${local.name}-vpc"
  environment = local.environment
  cidr_block  = "172.16.0.0/16"
}

##------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
##------------------------------------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.3"

  name               = "${local.name}-public-subnet"
  environment        = local.environment
  availability_zones = ["eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
}

# ################################################################################
# Security Groups module call
################################################################################

module "sg_rules" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.3"

  name        = "${local.name}-sg"
  environment = local.environment
  vpc_id      = module.vpc.vpc_id
  new_sg_ingress_rules = [{
    key         = "ssh-vpc"
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_ipv4   = local.vpc_cidr_block
    description = "Allow ssh traffic from VPC."
    },
    {
      key         = "ssh-additional"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = local.additional_cidr_block
      description = "Allow ssh traffic from additional CIDR."
    },
    {
      key         = "es-api"
      ip_protocol = "tcp"
      from_port   = 9200
      to_port     = 9200
      cidr_ipv4   = local.additional_cidr_block
      description = "Allow ES API traffic."
    },
    {
      key         = "http"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = local.vpc_cidr_block
      description = "Allow http traffic."
    },
    {
      key         = "https"
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ipv4   = local.vpc_cidr_block
      description = "Allow https traffic."
  }]

  ## EGRESS Rules
  new_sg_egress_rules = [{
    key         = "egress-ipv4"
    ip_protocol = "-1"
    from_port   = 0
    to_port     = 0
    cidr_ipv4   = "0.0.0.0/0"
    description = "Allow all IPV4 traffic."
    },
    {
      key         = "egress-ipv6"
      ip_protocol = "-1"
      from_port   = 0
      to_port     = 0
      cidr_ipv6   = "::/0"
      description = "Allow all IPV6 traffic."
    }
  ]
}
##------------------------------------------------------------------------------
## elasticsearch module call.
##------------------------------------------------------------------------------
module "elasticsearch" {
  source = "../../"

  name        = local.name
  environment = local.environment
  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]

  #Networking
  vpc_enabled        = true
  security_group_ids = [module.sg_rules.security_group_id]
  subnet_ids         = tolist(module.public_subnets.public_subnet_id)

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
