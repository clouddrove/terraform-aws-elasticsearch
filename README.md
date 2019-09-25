<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS Elasticsearch
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module to create an Elasticsearch resource on AWS.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v0.12-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-elasticsearch'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+Elasticsearch&url=https://github.com/clouddrove/terraform-aws-elasticsearch'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+Elasticsearch&url=https://github.com/clouddrove/terraform-aws-elasticsearch'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards stratergies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure.

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies:

- [Terraform 0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-elasticsearch/releases).


### Simple Example
Here is an example of how you can use this module in your inventory structure:
```hcl
    module "elasticsearch" {
      source                  = "git::https://github.com/clouddrove/terraform-aws-elasticsearch.git?ref=tags/0.12.0"
      name                    = "es"
      application             = "clouddrove"
      environment             = "test"
      label_order             = ["environment", "name", "application"]
      domain_name             = "clouddrove"
      enable_iam_service_linked_role = true
      security_group_ids      = ["sg-xxxxxxxxxxx"]
      subnet_ids              = ["subnet-xxxxxxxxxxx"]
      zone_awareness_enabled  = true
      elasticsearch_version   = "6.5"
      instance_type           = "t2.small.elasticsearch"
      instance_count          = 4
      iam_actions             = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
      volume_size             = 10
      volume_type             = "gp2"
      advanced_options        = {
                                  "rest.action.multi.allow_explicit_index" = "true"
                                }
    }
```
Note: There are some type of instances which not support encryption and EBS option, Please read about this (here)[https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html]






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| advanced_options | Key-value string pairs to specify advanced configuration options. | map(string) | `<map>` | no |
| application | Application (e.g. `cd` or `clouddrove`). | string | `` | no |
| attributes | Additional attributes (e.g. `1`). | list | `<list>` | no |
| automated_snapshot_start_hour | Hour at which automated snapshots are taken, in UTC. | number | `0` | no |
| availability_zone_count | Number of Availability Zones for the domain to use. | number | `2` | no |
| dedicated_master_count | Number of dedicated master nodes in the cluster. | number | `0` | no |
| dedicated_master_enabled | Indicates whether dedicated master nodes are enabled for the cluster. | bool | `false` | no |
| dedicated_master_type | Instance type of the dedicated master nodes in the cluster. | string | `t2.small.elasticsearch` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | string | `-` | no |
| domain_name | Domain name. | string | `` | no |
| elasticsearch_version | Version of Elasticsearch to deploy. | string | `6.5` | no |
| enable_iam_service_linked_role | Whether to enabled service linked with role. | bool | `false` | no |
| enabled | Set to false to prevent the module from creating any resources. | bool | `true` | no |
| encrypt_at_rest_enabled | Whether to enable encryption at rest. | bool | `true` | no |
| encryption_enabled | Whether to enable node-to-node encryption. | bool | `false` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | string | `` | no |
| iam_actions | List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`. | list(string) | `<list>` | no |
| iam_authorizing_role_arns | List of IAM role ARNs to permit to assume the Elasticsearch user role. | list(string) | `<list>` | no |
| iam_role_arns | List of IAM role ARNs to permit access to the Elasticsearch domain. | list(string) | `<list>` | no |
| instance_count | Number of data nodes in the cluster. | number | `4` | no |
| instance_type | Elasticsearch instance type for data nodes in the cluster. | string | `t2.small.elasticsearch` | no |
| iops | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type. | number | `0` | no |
| kms_key_id | The KMS key ID to encrypt the Elasticsearch domain with. If not specified, then it defaults to using the AWS/Elasticsearch service KMS key. | string | `` | no |
| label_order | Label order, e.g. `name`,`application`. | list | `<list>` | no |
| log_publishing_application_cloudwatch_log_group_arn | ARN of the CloudWatch log group to which log for ES_APPLICATION_LOGS needs to be published. | string | `` | no |
| log_publishing_application_enabled | Specifies whether log publishing option for ES_APPLICATION_LOGS is enabled or not. | bool | `false` | no |
| log_publishing_index_cloudwatch_log_group_arn | ARN of the CloudWatch log group to which log for INDEX_SLOW_LOGS needs to be published. | string | `` | no |
| log_publishing_index_enabled | Specifies whether log publishing option for INDEX_SLOW_LOGS is enabled or not. | bool | `false` | no |
| log_publishing_search_cloudwatch_log_group_arn | ARN of the CloudWatch log group to which log for SEARCH_SLOW_LOGS needs to be published. | string | `` | no |
| log_publishing_search_enabled | Specifies whether log publishing option for SEARCH_SLOW_LOGS is enabled or not. | bool | `false` | no |
| name | Name  (e.g. `app` or `cluster`). | string | `` | no |
| security_group_ids | Security Group IDs. | list(string) | - | yes |
| subnet_ids | Subnet IDs. | list(string) | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | map | `<map>` | no |
| volume_size | EBS volumes for data storage in GB. | number | `0` | no |
| volume_type | Storage type of EBS volumes. | string | `gp2` | no |
| zone_awareness_enabled | Enable zone awareness for Elasticsearch cluster. | bool | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain_arn | ARN of the Elasticsearch domain. |
| tags | A mapping of tags to assign to the resource. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system.

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-elasticsearch/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-elasticsearch)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=