output "product_name" {
  description = "Name of the Service Catalog product"
  value       = aws_servicecatalog_product.web_app_product.name
}

output "portfolio_name" {
  description = "Name of the Service Catalog portfolio"
  value       = aws_servicecatalog_portfolio.web_app_portfolio.name
}
