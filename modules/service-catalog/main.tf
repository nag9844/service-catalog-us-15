# Service Catalog Portfolio
resource "aws_servicecatalog_portfolio" "main" {
  name         = var.portfolio_name
  description  = var.portfolio_description
  provider_name = "DevOps Team"
  
  tags = var.tags
}

# CloudFormation template for EC2 Hello World
locals {
  cloudformation_template = jsonencode({
    AWSTemplateFormatVersion = "2010-09-09"
    Description = "EC2 instance with Hello World web server using Nginx"
    
    Parameters = {
      InstanceType = {
        Type = "String"
        Default = "t3.micro"
        AllowedValues = ["t3.micro", "t3.small", "t3.medium"]
        Description = "EC2 instance type"
      }
      KeyPairName = {
        Type = "String"
        Description = "Name of an existing EC2 KeyPair for SSH access"
        Default = ""
      }
      AllowedCIDR = {
        Type = "String"
        Default = "0.0.0.0/0"
        Description = "CIDR block allowed to access the web server"
      }
    }
    
    Mappings = {
      RegionMap = {
        "us-east-1" = { AMI = "ami-09e6f87a47903347c" }
        "ap-south-1" = { AMI = "ami-0b09627181c8d5778" }
      }
    }
    
    Resources = {
      WebServerSecurityGroup = {
        Type = "AWS::EC2::SecurityGroup"
        Properties = {
          GroupDescription = "Security group for Hello World web server"
          SecurityGroupIngress = [
            {
              IpProtocol = "tcp"
              FromPort = 80
              ToPort = 80
              CidrIp = { Ref = "AllowedCIDR" }
            },
            {
              IpProtocol = "tcp"
              FromPort = 22
              ToPort = 22
              CidrIp = { Ref = "AllowedCIDR" }
            }
          ]
          Tags = [
            {
              Key = "Name"
              Value = "HelloWorld-SecurityGroup"
            }
          ]
        }
      }
      
      WebServerInstance = {
        Type = "AWS::EC2::Instance"
        Properties = {
          ImageId = {
            "Fn::FindInMap" = ["RegionMap", { Ref = "AWS::Region" }, "AMI"]
          }
          InstanceType = { Ref = "InstanceType" }
          KeyName = {
            "Fn::If" = [
              "HasKeyPair",
              { Ref = "KeyPairName" },
              { Ref = "AWS::NoValue" }
            ]
          }
          SecurityGroupIds = [{ Ref = "WebServerSecurityGroup" }]
          UserData = {
            "Fn::Base64" = {
              "Fn::Sub" = join("\n", [
                "#!/bin/bash",
                "yum update",
                "amazon-linux-extras install -y nginx1",
                "systemctl enable nginx",
                "systemctl start nginx",
                "",
                "# Replace default nginx page with custom HTML",
                "cat > /usr/share/nginx/html/index.html << 'HTML_EOF'",
                "<!DOCTYPE html>",
                "<html>",
                "  <head>",
                "    <title>Hello World</title>",
                "  </head>",
                "  <body>",
                "    <h1>Hello, World from EC2!</h1>",
                "  </body>",
                "</html>",
                "HTML_EOF"
              ])
            }
          }
          Tags = [
            {
              Key = "Name"
              Value = "HelloWorld-WebServer"
            },
            {
              Key = "DeployedBy"
              Value = "ServiceCatalog"
            },
            {
              Key = "WebServer"
              Value = "Nginx"
            }
          ]
        }
      }
    }
    
    Conditions = {
      HasKeyPair = {
        "Fn::Not" = [
          { "Fn::Equals" = [{ Ref = "KeyPairName" }, ""] }
        ]
      }
    }
    
    Outputs = {
      WebServerPublicIP = {
        Description = "Public IP address of the web server"
        Value = { "Fn::GetAtt" = ["WebServerInstance", "PublicIp"] }
      }
      WebServerURL = {
        Description = "URL to access the Hello World page"
        Value = {
          "Fn::Join" = ["", ["http://", { "Fn::GetAtt" = ["WebServerInstance", "PublicIp"] }]]
        }
      }
      InstanceId = {
        Description = "EC2 Instance ID"
        Value = { Ref = "WebServerInstance" }
      }
    }
  })
}

# Service Catalog Product
resource "aws_servicecatalog_product" "hello_world" {
  name         = var.product_name
  description  = var.product_description
  owner        = "DevOps Team"
  type         = "CLOUD_FORMATION_TEMPLATE"
  
  provisioning_artifact_parameters {
    name        = "v1.0"
    description = "Initial version of Hello World web server with Nginx"
    template_url = ""
    type        = "CLOUD_FORMATION_TEMPLATE"
    template_physical_id = base64encode(local.cloudformation_template)
  }
  
  tags = var.tags
}

# Associate product with portfolio
resource "aws_servicecatalog_product_portfolio_association" "hello_world" {
  portfolio_id = aws_servicecatalog_portfolio.main.id
  product_id   = aws_servicecatalog_product.hello_world.id
}

# Launch constraint
resource "aws_servicecatalog_constraint" "launch_constraint" {
  description  = "Launch constraint for Hello World product"
  portfolio_id = aws_servicecatalog_portfolio.main.id
  product_id   = aws_servicecatalog_product.hello_world.id
  type         = "LAUNCH"
  
  parameters = jsonencode({
    RoleArn = var.launch_constraint_role_arn
  })
  
  depends_on = [aws_servicecatalog_product_portfolio_association.hello_world]
}

# Portfolio access for end users
resource "aws_servicecatalog_principal_portfolio_association" "end_users" {
  portfolio_id  = aws_servicecatalog_portfolio.main.id
  principal_arn = var.portfolio_access_role_arn
}