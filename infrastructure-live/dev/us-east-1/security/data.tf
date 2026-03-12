#backend = "local" tells Terraform where to find the "Receipt" (State file) for 
#your other modules. 
#Terraform treats every directory (network, security, bastion) as a completely separate project.
#The Bastion folder has no idea that the Network folder exists on your hard drive.
#Declaring the local backend gives the Bastion "permission" to look inside the network/terraform.tfstate file to find the VPC ID.

# Fetch VPC and Subnet IDs from the Network State File
# data "terraform_remote_state" "vpc" {
#   backend = "local"

#   config = {
#     # Path to where your network/terraform.tfstate sits
#     path = "../network/terraform.tfstate"
#   }
# }
#OR
data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/vpc-id"
}
# 2. Fetch Public Subnet IDs from SSM
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/public_subnet_ids"
}
# 3. Fetch Private Subnet IDs from SSM
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/private_subnet_ids"
}
# 4. Fetch Database Subnet IDs from SSM
data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/database_subnet_ids"
}
# 1. Search for an IGW attached to your VPC
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }
}

# 2. Search for a NAT Gateway in your VPC
data "aws_nat_gateways" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }
}
# Step 2: Get the specific details (like public_ip) for the first NAT Gateway found
data "aws_nat_gateway" "selected" {
  # Only run this if at least one NAT Gateway was found
  count = length(data.aws_nat_gateways.all.ids) > 0 ? 1 : 0
  id    = data.aws_nat_gateways.all.ids[0]
}
# data "aws_ssm_parameter" "igw_id" {
  
#   name = "/${title(var.project_name)}/${title(var.env)}/vpc/igw_id"
# }
# data "aws_ssm_parameter" "nat_eip_public_ip" {
#   name = "/${title(var.project_name)}/${title(var.env)}/vpc/nat_eip_public_ip"
# }
# data "aws_ssm_parameter" "nat_gateway_id" {
#    name = "/${title(var.project_name)}/${title(var.env)}/vpc/nat_gateway_id"
# }

