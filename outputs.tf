output "product_name" {
  description = "Name of the Service Catalog product"
  value       = aws_servicecatalog_product.ec2_product.name
}

output "portfolio_name" {
  description = "Name of the Service Catalog portfolio"
  value       = aws_servicecatalog_portfolio.sc_portfolio.name
}
