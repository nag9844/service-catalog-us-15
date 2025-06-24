variable "portfolio_name" {
  description = "Name of the Service Catalog portfolio (used for role naming)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}