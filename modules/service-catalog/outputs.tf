output "portfolio_id" {
  description = "ID of the created Service Catalog portfolio"
  value       = aws_servicecatalog_portfolio.main.id
}

output "portfolio_arn" {
  description = "ARN of the created Service Catalog portfolio"
  value       = aws_servicecatalog_portfolio.main.arn
}

output "product_id" {
  description = "ID of the created Service Catalog product"
  value       = aws_servicecatalog_product.hello_world.id
}

output "product_arn" {
  description = "ARN of the created Service Catalog product"
  value       = aws_servicecatalog_product.hello_world.arn
}