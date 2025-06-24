# Data source for current AWS account
data "aws_caller_identity" "current" {}

# IAM role for Service Catalog portfolio access
resource "aws_iam_role" "portfolio_access" {
  name = "${var.portfolio_name}-PortfolioAccess-Role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "servicecatalog.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for Service Catalog end users
resource "aws_iam_policy" "portfolio_access" {
  name        = "${var.portfolio_name}-PortfolioAccess-Policy"
  description = "Policy for Service Catalog portfolio access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "servicecatalog:ListPortfolios",
          "servicecatalog:DescribePortfolio",
          "servicecatalog:SearchProducts",
          "servicecatalog:DescribeProduct",
          "servicecatalog:DescribeProductView",
          "servicecatalog:DescribeProvisioningParameters",
          "servicecatalog:ProvisionProduct",
          "servicecatalog:UpdateProvisionedProduct",
          "servicecatalog:TerminateProvisionedProduct",
          "servicecatalog:DescribeRecord",
          "servicecatalog:ListRecordHistory",
          "servicecatalog:ScanProvisionedProducts",
          "servicecatalog:DescribeProvisionedProduct",
          "servicecatalog:CreateProvisionedProductPlan",
          "servicecatalog:DescribeProvisionedProductPlan",
          "servicecatalog:ExecuteProvisionedProductPlan",
          "servicecatalog:DeleteProvisionedProductPlan",
          "servicecatalog:ListProvisionedProductPlans"
        ]
        Resource = "*"
      }
    ]
  })
  
  tags = var.tags
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "portfolio_access" {
  role       = aws_iam_role.portfolio_access.name
  policy_arn = aws_iam_policy.portfolio_access.arn
}

# IAM role for Service Catalog launch constraint
resource "aws_iam_role" "launch_constraint" {
  name = "${var.portfolio_name}-LaunchConstraint-Role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "servicecatalog.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

# IAM policy for launch constraint role
resource "aws_iam_policy" "launch_constraint" {
  name        = "${var.portfolio_name}-LaunchConstraint-Policy"
  description = "Policy for Service Catalog launch constraint"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "cloudformation:*",
          "iam:PassRole",
          "iam:GetRole"
        ]
        Resource = "*"
      }
    ]
  })
  
  tags = var.tags
}

# Attach launch constraint policy to role
resource "aws_iam_role_policy_attachment" "launch_constraint" {
  role       = aws_iam_role.launch_constraint.name
  policy_arn = aws_iam_policy.launch_constraint.arn
}