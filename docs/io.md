## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| advanced\_options | Key-value string pairs to specify advanced configuration options. | `map(string)` | `{}` | no |
| advanced\_security\_options\_enabled | AWS Elasticsearch Kibana enchanced security plugin enabling (forces new resource) | `bool` | `false` | no |
| advanced\_security\_options\_internal\_user\_database\_enabled | Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin | `bool` | `false` | no |
| advanced\_security\_options\_master\_user\_arn | ARN of IAM user who is to be mapped to be Kibana master user (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to false) | `string` | `""` | no |
| advanced\_security\_options\_master\_user\_name | Master user username (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `""` | no |
| advanced\_security\_options\_master\_user\_password | Master user password (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `""` | no |
| allowed\_cidr\_blocks | List of CIDR blocks to be allowed to connect to the cluster | `list(string)` | `[]` | no |
| attributes | Additional attributes (e.g. `1`). | `list(any)` | `[]` | no |
| auto\_tune\_desired\_state | Desired state of Auto-Tune for the domain. Valid values are ENABLED, DISABLED. | `string` | `"DISABLED"` | no |
| automated\_snapshot\_start\_hour | Hour at which automated snapshots are taken, in UTC. | `number` | `0` | no |
| availability\_zone\_count | Number of Availability Zones for the domain to use. | `number` | `2` | no |
| cloudwatch\_kms\_key\_id | The KMS key ID to encrypt the Cloudwatch logs. | `string` | `""` | no |
| cognito\_enabled | Set to false to prevent enable cognito. | `bool` | `true` | no |
| custom\_endpoint | Fully qualified domain for custom endpoint. | `string` | `""` | no |
| custom\_endpoint\_certificate\_arn | ACM certificate ARN for custom endpoint. | `string` | `""` | no |
| custom\_endpoint\_enabled | Whether to enable custom endpoint for the Elasticsearch domain. | `bool` | `false` | no |
| dedicated\_master\_count | Number of dedicated master nodes in the cluster. | `number` | `0` | no |
| dedicated\_master\_enabled | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `false` | no |
| dedicated\_master\_type | Instance type of the dedicated master nodes in the cluster. | `string` | `"t2.small.elasticsearch"` | no |
| dns\_enabled | Flag to control the dns\_enable. | `bool` | `false` | no |
| dns\_zone\_id | Route53 DNS Zone ID to add hostname records for Elasticsearch domain and Kibana. | `string` | `""` | no |
| domain\_name | Domain name. | `string` | `""` | no |
| elasticsearch\_version | Version of Elasticsearch to deploy. | `string` | `"6.5"` | no |
| enable\_iam\_service\_linked\_role | Whether to enabled service linked with role. | `bool` | `false` | no |
| enable\_logs | enable logs | `bool` | `true` | no |
| enabled | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| encrypt\_at\_rest\_enabled | Whether to enable encryption at rest. | `bool` | `true` | no |
| encryption\_enabled | Whether to enable node-to-node encryption. | `bool` | `true` | no |
| enforce\_https | Whether or not to require HTTPS. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| es\_hostname | The Host name of elasticserch. | `string` | `""` | no |
| iam\_actions | List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`. | `list(string)` | `[]` | no |
| identity\_pool\_id | ID of the Cognito Identity Pool to use. | `string` | `""` | no |
| instance\_count | Number of data nodes in the cluster. | `number` | `4` | no |
| instance\_type | Elasticsearch instance type for data nodes in the cluster. | `string` | `"t2.small.elasticsearch"` | no |
| iops | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type. | `number` | `0` | no |
| kibana\_hostname | The Host name of kibana. | `string` | `""` | no |
| kms\_key\_id | The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| log\_publishing\_application\_enabled | Specifies whether log publishing option for ES\_APPLICATION\_LOGS is enabled or not. | `bool` | `false` | no |
| log\_publishing\_audit\_enabled | Specifies whether log publishing option for AUDIT\_LOGS is enabled or not. | `bool` | `true` | no |
| log\_publishing\_index\_enabled | Specifies whether log publishing option for INDEX\_SLOW\_LOGS is enabled or not. | `bool` | `false` | no |
| log\_publishing\_search\_enabled | Specifies whether log publishing option for SEARCH\_SLOW\_LOGS is enabled or not. | `bool` | `false` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-elasticsearch"` | no |
| retention\_in\_days | Days of retention of cloudwatch. | `number` | `90` | no |
| rollback\_on\_disable | Whether to roll back to default Auto-Tune settings when disabling Auto-Tune. Valid values: DEFAULT\_ROLLBACK or NO\_ROLLBACK. | `string` | `"DEFAULT_ROLLBACK"` | no |
| security\_group\_ids | Security Group IDs. | `list(string)` | `[]` | no |
| subnet\_ids | Subnet IDs. | `list(string)` | `[]` | no |
| tls\_security\_policy | The name of the TLS security policy that needs to be applied to the HTTPS endpoint. | `string` | `"Policy-Min-TLS-1-0-2019-07"` | no |
| ttl | The TTL of the record to add to the DNS zone to complete certificate validation. | `string` | `"300"` | no |
| type | Type of DNS records to create. | `string` | `"CNAME"` | no |
| user\_pool\_id | ID of the Cognito User Pool to use. | `string` | `""` | no |
| volume\_size | EBS volumes for data storage in GB. | `number` | `0` | no |
| volume\_type | Storage type of EBS volumes. | `string` | `"gp2"` | no |
| vpc\_enabled | Set to false if ES should be deployed outside of VPC. | `bool` | `true` | no |
| warm\_count | Number of UltraWarm nodes | `number` | `2` | no |
| warm\_enabled | Whether AWS UltraWarm is enabled | `bool` | `false` | no |
| warm\_type | Type of UltraWarm nodes | `string` | `"ultrawarm1.medium.elasticsearch"` | no |
| zone\_awareness\_enabled | Enable zone awareness for Elasticsearch cluster. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain\_arn | ARN of the Elasticsearch domain. |
| tags | A mapping of tags to assign to the resource. |

