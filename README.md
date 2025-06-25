## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.launch_constraint_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.service_catalog_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.launch_constraint_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.template_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_object.web_app_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_servicecatalog_constraint.web_app_launch_constraint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_constraint) | resource |
| [aws_servicecatalog_portfolio.web_app_portfolio](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_portfolio) | resource |
| [aws_servicecatalog_principal_portfolio_association.developer_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_principal_portfolio_association) | resource |
| [aws_servicecatalog_product.web_app_product](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product) | resource |
| [aws_servicecatalog_product_portfolio_association.web_app_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/servicecatalog_product_portfolio_association) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [template_file.web_app_template](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy resources in | `string` | `"ap-south-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_portfolio_name"></a> [portfolio\_name](#output\_portfolio\_name) | Name of the Service Catalog portfolio |
| <a name="output_product_name"></a> [product\_name](#output\_product\_name) | Name of the Service Catalog product |
