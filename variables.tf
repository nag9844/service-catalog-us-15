variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "ap-south-1"
}

variable "portfolio_name" {
  description = "Name of the Service Catalog portfolio"
  type        = string
  default     = "Hello World Portfolio"
}

variable "portfolio_description" {
  description = "Description of the Service Catalog portfolio"
  type        = string
  default     = "Portfolio containing EC2 hello world web server products"
}

variable "product_name" {
  description = "Name of the Service Catalog product"
  type        = string
  default     = "Hello World Web Server"
}

variable "product_description" {
  description = "Description of the Service Catalog product"
  type        = string
  default     = "EC2 instance running a simple hello world web server"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "HelloWorldServiceCatalog"
    Environment = "demo"
    ManagedBy   = "Terraform"
  }
}