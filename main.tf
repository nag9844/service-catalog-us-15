terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
  }

  required_version = ">= 1.3"
}

provider "aws" {
  region = var.region
}

# Create a random ID for uniqueness (especially for bucket names)
resource "random_id" "rand" {
  byte_length = 4
}

# IAM Role for Service Catalog launch constraint
resource "aws_iam_role" "launch_role" {
  name = "sc-ec2-launch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "servicecatalog.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.launch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Create an S3 bucket to host the CloudFormation template
resource "aws_s3_bucket" "cf_templates" {
  bucket        = "sc-product-templates-${random_id.rand.hex}"
  force_destroy = true
}

# Upload the CloudFormation template to the bucket
resource "aws_s3_object" "ec2_product_template" {
  bucket = aws_s3_bucket.cf_templates.id
  key    = "ec2-product.yaml"
  source = "${path.module}/ec2-product.yaml"
  etag   = filemd5("${path.module}/ec2-product.yaml")
  content_type = "text/yaml"
}

# Create Service Catalog Portfolio
resource "aws_servicecatalog_portfolio" "sc_portfolio" {
  name          = "DevOpsTools"
  description   = "Portfolio for launching EC2 with Hello World"
  provider_name = "Terraform"
}

# Create Service Catalog Product using the CloudFormation template from S3
resource "aws_servicecatalog_product" "ec2_product" {
  name        = "EC2 HelloWorld"
  owner       = "DevOps Team"
  description = "This product launches an EC2 instance displaying a Hello World page"
  type        = "CLOUD_FORMATION_TEMPLATE"

  provisioning_artifact_parameters {
    name         = "v1"
    description  = "Initial version"
    type         = "CLOUD_FORMATION_TEMPLATE"
    template_url = "https://${aws_s3_bucket.cf_templates.bucket}.s3.amazonaws.com/${aws_s3_object.ec2_product_template.key}"
  }

  tags = {
    Environment = "Dev"
  }
}

# Associate the product with the portfolio
resource "aws_servicecatalog_portfolio_product_association" "association" {
  portfolio_id = aws_servicecatalog_portfolio.sc_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
}

# Define a launch constraint linking the product to the IAM role
resource "aws_servicecatalog_launch_constraint" "launch_constraint" {
  portfolio_id = aws_servicecatalog_portfolio.sc_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
  role_arn     = aws_iam_role.launch_role.arn
}
