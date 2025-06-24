# Terraform configuration to set up an AWS Service Catalog product that
# provisions an EC2 instance with a "Hello World" web page

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

# variable "region" {
#   default = "ap-south-1"
# }

resource "random_id" "rand" {
  byte_length = 4
}

# S3 bucket to store the CloudFormation template
resource "aws_s3_bucket" "cf_templates" {
  bucket        = "sc-product-templates-${random_id.rand.hex}"
  force_destroy = true
}

resource "aws_s3_object" "ec2_product_template" {
  bucket        = aws_s3_bucket.cf_templates.id
  key           = "ec2-product.yaml"
  source        = "${path.module}/ec2-product.yaml"
  etag          = filemd5("${path.module}/ec2-product.yaml")
  content_type  = "text/yaml"
}

resource "aws_s3_bucket_policy" "cf_templates_policy" {
  bucket = aws_s3_bucket.cf_templates.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.launch_role.arn
        },
        Action = [
          "s3:GetObject"
        ],
        Resource = "${aws_s3_bucket.cf_templates.arn}/*"
      }
    ]
  })
}


# IAM role for Service Catalog to launch EC2
resource "aws_iam_role" "launch_role" {
  name = "sc-ec2-launch-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "servicecatalog.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.launch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Service Catalog portfolio
resource "aws_servicecatalog_portfolio" "sc_portfolio" {
  name          = "DevOpsTools"
  description   = "Portfolio for launching EC2 with Hello World"
  provider_name = "Terraform"
}

# Service Catalog product
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
resource "aws_servicecatalog_product_portfolio_association" "association" {
  portfolio_id = aws_servicecatalog_portfolio.sc_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
}

# Define a launch constraint
resource "aws_servicecatalog_constraint" "launch_constraint" {
  portfolio_id = aws_servicecatalog_portfolio.sc_portfolio.id
  product_id   = aws_servicecatalog_product.ec2_product.id
  type         = "LAUNCH"
  parameters   = jsonencode({
    RoleArn = aws_iam_role.launch_role.arn
  })
}

# IAM role for end user launching the product
resource "aws_iam_role" "sc_end_user_role" {
  name = "SC-EndUser-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "sc_end_user_policy" {
  name = "SC-EndUser-Policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "servicecatalog:*",
          "cloudformation:GetTemplateSummary",
          "ec2:Describe*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sc_end_user_attach" {
  role       = aws_iam_role.sc_end_user_role.name
  policy_arn = aws_iam_policy.sc_end_user_policy.arn
}

resource "aws_iam_role_policy_attachment" "cloudformation_full_access" {
  role       = aws_iam_role.launch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

# Data source to get account ID
data "aws_caller_identity" "current" {}
