data "aws_ami" "ami" {
  most_recent = true
  owners      = [var.owner_id]

  filter {
    name   = "name"
    values = [var.ami_name]
  }
}
data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.environment)}/vpc/vpc-id"
}
# 2. Fetch Private Subnet IDs from SSM
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.environment)}/vpc/private_subnet_ids"
}
data "aws_ssm_parameter" "sg_id" {
  name = "/${title(var.project_name)}/${title(var.environment)}/${title(var.component)}_sg-id"
}
# data "aws_ssm_parameter" "backend_alb_sg_id" {
#   name = "/${title(var.project_name)}/${title(var.environment)}/Backend_alb_sg-id"
# }
data "aws_ssm_parameter" "backend_alb_listener_arn" {
  name = "/${title(var.project_name)}/${title(var.environment)}/alb/backend_listener_arn"
}
data "aws_ssm_parameter" "frontend_listener_arn" {
  name = "/${title(var.project_name)}/${title(var.environment)}/alb/frontend_listener_arn"

}