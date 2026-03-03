project_name = "Roboshop"
common_tags = {
    Environment = "dev"
    Terraform = "true"
    component = "networking"
}

# The VPC range
vpc_cidr     = "10.0.0.0/16"

# The Subnet ranges (Dev only needs 2 of each for now)
public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Mandatory tags for all 10 services
# common_tags = {
#   Project     = "Roboshop"
#   Environment = "dev"
#   Terraform   = "true"
# }