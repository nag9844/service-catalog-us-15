# AWS Service Catalog with Hello World EC2 Deployment

This Terraform configuration creates an AWS Service Catalog setup that allows users to launch EC2 instances running a beautiful Hello World web server.

## Architecture

- **Service Catalog Portfolio**: Contains the Hello World product
- **Service Catalog Product**: CloudFormation template for EC2 deployment
- **IAM Roles**: Proper permissions for portfolio access and product launching
- **EC2 Instance**: Runs Apache with a custom Hello World page
- **Security Group**: Allows HTTP (80) and SSH (22) access

## Features

- 🎨 Beautiful, responsive Hello World web page
- 🔒 Secure IAM role-based access control
- 🚀 One-click deployment via Service Catalog
- 📊 Instance information display on the web page
- 🏷️ Comprehensive resource tagging
- 🔧 Configurable instance types (t3.micro, t3.small, t3.medium)

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- AWS account with Service Catalog permissions

## Quick Start

1. **Clone and Navigate**:
   ```bash
   cd terraform
   ```

2. **Configure Variables**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your desired values
   ```

3. **Initialize and Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Access Service Catalog**:
   - Go to AWS Console → Service Catalog
   - Find your portfolio
   - Launch the "Hello World Web Server" product
   - Wait for deployment to complete
   - Access the provided public IP address

## Configuration

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for deployment | `ap-south-1` |
| `portfolio_name` | Service Catalog portfolio name | `Hello World Portfolio` |
| `product_name` | Service Catalog product name | `Hello World Web Server` |
| `common_tags` | Tags applied to all resources | See variables.tf |

### Product Parameters

When launching the product through Service Catalog, you can configure:

- **Instance Type**: t3.micro, t3.small, or t3.medium
- **Key Pair**: Optional SSH key for instance access
- **Allowed CIDR**: IP range allowed to access the web server

## Outputs

After deployment, Terraform provides:

- Portfolio ID and console URL
- Product ID
- IAM role ARNs

After launching the product via Service Catalog:

- EC2 Instance Public IP
- Hello World Web Server URL
- Instance ID

## Security

- EC2 security group restricts access to HTTP (80) and SSH (22)
- IAM roles follow principle of least privilege
- Launch constraints ensure proper role assumption
- All resources are properly tagged for governance

## Web Page Features

The deployed Hello World page includes:

- Modern, responsive design with gradient backgrounds
- Instance metadata display (ID, region, type)
- Deployment timestamp
- Success indicators
- Professional typography and styling

## Cleanup

To remove all resources:

```bash
# First, terminate any launched Service Catalog products
# Then destroy the Terraform infrastructure
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Insufficient Permissions**: Ensure your AWS credentials have Service Catalog and IAM permissions
2. **Instance Launch Fails**: Check the launch constraint role has necessary EC2 permissions
3. **Web Page Not Loading**: Verify security group allows inbound HTTP traffic

### Logs

- CloudFormation events in AWS Console
- EC2 instance logs via Systems Manager or SSH
- Service Catalog provisioning history

## Module Structure

```
terraform/
├── main.tf              # Root configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values (create from example)
└── modules/
    ├── service-catalog/ # Service Catalog resources
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── iam/            # IAM roles and policies
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Next Steps

1. Customize the CloudFormation template for additional features
2. Add more products to the portfolio
3. Implement budget controls and notifications
4. Set up automated testing of deployed resources
5. Add monitoring and alerting for deployed instances

## Support

For issues or questions:
1. Check AWS CloudFormation events for deployment errors
2. Review Terraform plan output before applying
3. Ensure all required AWS services are available in your region