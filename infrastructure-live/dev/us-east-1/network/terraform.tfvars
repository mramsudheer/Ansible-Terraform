# The VPC range
vpc_cidr = "10.0.0.0/16"

# The Subnet ranges (Dev only needs 2 of each for now)
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
database_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]

azs                = ["us-east-1a", "us-east-1b"]
nat_gateway_enable = true
static_ip          = ""
environment        = "dev"

project_name = "Roboshop"
common_tags = {
  Environment = "dev"
  Terraform   = "true"
  component   = "networking"
}


# Mandatory tags for all 10 services
# common_tags = {
#   Project     = "Roboshop"
#   Environment = "dev"
#   Terraform   = "true"
# }