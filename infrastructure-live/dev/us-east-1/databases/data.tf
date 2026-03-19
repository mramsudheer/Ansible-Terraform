data "aws_ami" "custom_ami" {
  most_recent = true
  owners      = [var.owner_id]
  filter {
    name   = "name"
    values = [var.ami_name]
  }
}
# 1. Fetch VPC ID from SSM
data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/vpc-id"
}
# 2. Fetch Private Subnet IDs from SSM
data "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/database_subnet_ids"
}
data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/Mongodb_sg-id"
}
data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/Redis_sg-id"
}