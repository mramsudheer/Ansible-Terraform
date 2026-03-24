data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/vpc-id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/private_subnet_ids"
}
data "aws_ssm_parameter" "backend_alb_sg_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/Backend_alb_sg-id"
}