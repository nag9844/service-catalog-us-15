output "portfolio_access_role_arn" {
  description = "ARN of the portfolio access role"
  value       = aws_iam_role.portfolio_access.arn
}

output "portfolio_access_role_name" {
  description = "Name of the portfolio access role"
  value       = aws_iam_role.portfolio_access.name
}

output "launch_constraint_role_arn" {
  description = "ARN of the launch constraint role"
  value       = aws_iam_role.launch_constraint.arn
}

output "launch_constraint_role_name" {
  description = "Name of the launch constraint role"
  value       = aws_iam_role.launch_constraint.name
}