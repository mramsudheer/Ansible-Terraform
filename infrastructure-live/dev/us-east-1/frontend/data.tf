data "aws_ami" "custom_ami" {
  most_recent = true
  owners      = [var.owner_id]
  filter {
    name   = "name"
    values = [var.ami_name]
  }
}
data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/vpc-id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/private_subnet_ids"
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/Frontend_sg-id"
}

# The Public Listener ARN we just created in the frontend_alb folder
data "aws_ssm_parameter" "frontend_listener_arn" {
  name = "/${title(var.project_name)}/${title(var.env)}/alb/frontend_listener_arn"
}

# data "aws_ami" "centos8" {
#   most_recent = true
#   owners      = ["973714476881"]
#   filter {
#     name   = "name"
#     values = ["Centos-8-DevOps-Practice"]
#   }
# }
