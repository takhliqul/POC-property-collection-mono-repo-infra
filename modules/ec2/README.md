# Module: EC2

## Overview
This section will store the module configuration for the application server.  

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2"></a> [ec2](#module\_ec2) | git::https://github.com/cloudposse/terraform-aws-ec2-instance | 0.44.0 |
| <a name="module_ec2_ebs_kms"></a> [ec2\_ebs\_kms](#module\_ec2\_ebs\_kms) | git::https://github.com/cloudposse/terraform-aws-kms-key | 0.12.1 |
| <a name="module_ec2_key_pair"></a> [ec2\_key\_pair](#module\_ec2\_key\_pair) | git::https://github.com/cloudposse/terraform-aws-key-pair | 0.18.3 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2_ebs_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | AMI ID for the EC2 instance | <pre>object({<br>    id            = string<br>    owner         = optional(string)<br>    instance_type = string<br>  })</pre> | <pre>{<br>  "id": "",<br>  "instance_type": "",<br>  "owner": ""<br>}</pre> | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | Optimize the EBS volume | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment the resource belongs to | `string` | n/a | yes |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | A pre-defined profile to attach to the instance (default is to build our own) | `string` | `""` | no |
| <a name="input_kms_admin_iam_role_identifier_arns"></a> [kms\_admin\_iam\_role\_identifier\_arns](#input\_kms\_admin\_iam\_role\_identifier\_arns) | IAM Role ARN to add to the KMS key for management. | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name to assign the resource | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace the resource belongs to | `string` | n/a | yes |
| <a name="input_root_volume_size"></a> [root\_volume\_size](#input\_root\_volume\_size) | Size of the root volume for the EC2 instance | `string` | `"20"` | no |
| <a name="input_root_volume_type"></a> [root\_volume\_type](#input\_root\_volume\_type) | Type of the root volume for the EC2 instance | `string` | `"gp2"` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | List of security group ingress and egress rules. | <pre>list(object({<br>    type        = string<br>    from_port   = number<br>    to_port     = number<br>    protocol    = string<br>    cidr_blocks = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Subnet id the resource belongs to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to assign the resources | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; use `user_data_base64` instead | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Id of the VPC where the resources will live | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_arn"></a> [ec2\_arn](#output\_ec2\_arn) | EC2 ARN |
| <a name="output_ec2_role"></a> [ec2\_role](#output\_ec2\_role) | EC2 role for attaching additional policies to |
| <a name="output_id"></a> [id](#output\_id) | Disambiguated ID of the instance |
| <a name="output_name"></a> [name](#output\_name) | EC2 instance name |
| <a name="output_private_dns"></a> [private\_dns](#output\_private\_dns) | EC2 instance private DNS |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | EC2 instance private IP addresses |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | EC2 Security Group arn |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | EC2 Security Group IDs |
<!-- END_TF_DOCS -->