output "portfolio_id" {
  description = "ID of the Service Catalog portfolio"
  value       = module.service_catalog.portfolio_id
}

output "product_id" {
  description = "ID of the Service Catalog product"
  value       = module.service_catalog.product_id
}

output "portfolio_access_role_arn" {
  description = "ARN of the portfolio access role"
  value       = module.iam.portfolio_access_role_arn
}

output "service_catalog_console_url" {
  description = "URL to access the Service Catalog in AWS Console"
  value       = "https://${var.aws_region}.console.aws.amazon.com/servicecatalog/home?region=${var.aws_region}#/portfolios"
}