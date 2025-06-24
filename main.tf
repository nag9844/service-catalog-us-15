terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create Service Catalog Portfolio and Product
module "service_catalog" {
  source = "./modules/service-catalog"
  
  portfolio_name        = var.portfolio_name
  portfolio_description = var.portfolio_description
  product_name         = var.product_name
  product_description  = var.product_description
  
  # IAM roles
  portfolio_access_role_arn = module.iam.portfolio_access_role_arn
  launch_constraint_role_arn = module.iam.launch_constraint_role_arn
  
  tags = var.common_tags
}

# IAM roles and policies
module "iam" {
  source = "./modules/iam"
  
  portfolio_name = var.portfolio_name
  tags          = var.common_tags
}

# Data sources for existing resources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}