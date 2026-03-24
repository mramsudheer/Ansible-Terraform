data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/vpc-id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.env)}/vpc/public_subnet_ids"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${title(var.project_name)}/${title(var.env)}/Frontend_alb_sg-id"
}

# Fetch the Certificate ARN from the ACM folder's SSM parameter
data "aws_ssm_parameter" "acm_certificate_arn" {
  name = "/${title(var.project_name)}/${title(var.env)}/acm/certificate_arn"
}
