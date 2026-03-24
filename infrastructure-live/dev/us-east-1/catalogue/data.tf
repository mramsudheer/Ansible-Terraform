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
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/private-subnet-ids"
}
# Fetch app-specific Security Group IDs
data "aws_ssm_parameter" "app_sgs" {
  for_each = toset(var.apps)
  name     = "/${title(var.project_name)}/${title(var.env)}/${title(each.key)}_sg-id"
}
# Fetch the shared Backend ALB Listener ARN
data "aws_ssm_parameter" "backend_listener_arn" {
  name = "/${title(var.project_name)}/${title(var.env)}/alb/backend_listener_arn"
}
# data "aws_ssm_parameter" "catalogue_sg_id" {
#   name = "/${title(var.project_name)}/${title(var.env)}/Catalogue_sg-id"
# }
# data "aws_ssm_parameter" "user_sg_id" {
#   name = "/${title(var.project_name)}/${title(var.env)}/User_sg-id"
# }
# data "aws_ssm_parameter" "cart_sg_id" {
#   name = "/${title(var.project_name)}/${title(var.env)}/Cart_sg-id"
# }
