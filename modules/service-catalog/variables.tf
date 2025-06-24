variable "portfolio_name" {
  description = "Name of the Service Catalog portfolio"
  type        = string
}

variable "portfolio_description" {
  description = "Description of the Service Catalog portfolio"
  type        = string
}

variable "product_name" {
  description = "Name of the Service Catalog product"
  type        = string
}

variable "product_description" {
  description = "Description of the Service Catalog product"
  type        = string
}

variable "portfolio_access_role_arn" {
  description = "ARN of the IAM role for portfolio access"
  type        = string
}

variable "launch_constraint_role_arn" {
  description = "ARN of the IAM role for launch constraints"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}