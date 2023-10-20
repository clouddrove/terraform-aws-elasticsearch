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
  version = "2.0.0"

  name        = "${local.name}-vpc"
  environment = local.environment
  cidr_block  = "172.16.0.0/16"
}

##------------------------------------------------------------------------------
## A subnet is a range of IP addresses in your VPC.
##------------------------------------------------------------------------------
module "public_subnets" {
  source  = "clouddrove/subnet/aws"
  version = "2.0.0"

  name               = "${local.name}-public-subnet"
  environment        = local.environment
  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
  type               = "public"
  igw_id             = module.vpc.igw_id
}

# ################################################################################
# Security Groups module call
################################################################################

module "ssh" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name        = "${local.name}-ssh"
  environment = local.environment
  vpc_id      = module.vpc.vpc_id
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [local.vpc_cidr_block, local.additional_cidr_block]
    description = "Allow ssh traffic."
    },
    {
      rule_count  = 2
      from_port   = 9200
      protocol    = "tcp"
      to_port     = 9200
      cidr_blocks = [local.additional_cidr_block]
      description = "Allow Mongodb traffic."
    }
  ]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [local.vpc_cidr_block, local.additional_cidr_block]
    description = "Allow ssh outbound traffic."
    },
    {
      rule_count  = 2
      from_port   = 9200
      protocol    = "tcp"
      to_port     = 9200
      cidr_blocks = [local.additional_cidr_block]
      description = "Allow Mongodb outbound traffic."
  }]
}

module "http_https" {
  source  = "clouddrove/security-group/aws"
  version = "2.0.0"

  name        = "${local.name}-http-https"
  environment = local.environment

  vpc_id = module.vpc.vpc_id
  ## INGRESS Rules
  new_sg_ingress_rules_with_cidr_blocks = [{
    rule_count  = 1
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [local.vpc_cidr_block]
    description = "Allow ssh traffic."
    },
    {
      rule_count  = 2
      from_port   = 80
      protocol    = "tcp"
      to_port     = 80
      cidr_blocks = [local.vpc_cidr_block]
      description = "Allow http traffic."
    },
    {
      rule_count  = 3
      from_port   = 443
      protocol    = "tcp"
      to_port     = 443
      cidr_blocks = [local.vpc_cidr_block]
      description = "Allow https traffic."
    }
  ]

  ## EGRESS Rules
  new_sg_egress_rules_with_cidr_blocks = [{
    rule_count       = 1
    from_port        = 0
    protocol         = "-1"
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all traffic."
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
  domain_name = "clouddrove"
  #IAM
  enable_iam_service_linked_role = false
  iam_actions                    = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  tls_security_policy            = "Policy-Min-TLS-1-0-2019-07"

  #Networking
  vpc_enabled             = true
  security_group_ids      = [module.ssh.security_group_id, module.http_https.security_group_id]
  subnet_ids              = tolist(module.public_subnets.public_subnet_id)
  availability_zone_count = length(module.public_subnets.public_subnet_id)
  zone_awareness_enabled  = true

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
