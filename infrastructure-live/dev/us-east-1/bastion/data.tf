# 1. Fetch VPC ID from SSM
data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/vpc-id"
}

# 2. Fetch Public Subnet IDs from SSM
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/public_subnet_ids"
}
# 3. Fetch VPC and Subnet IDs from the Network State File
# data "terraform_remote_state" "vpc" {
#   backend = "local"

#   config = {
#     # Path to where your network/terraform.tfstate sits
#     path = "../network/terraform.tfstate"
#   }
# }
# 4. Fetch the Bastion Security Group ID from SSM Parameter Store
data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/Bastion_sg-id"
}
data "aws_ami" "joindevops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }
}