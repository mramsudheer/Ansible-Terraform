locals {
  ami_id             = data.aws_ami.ami.id
  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  sg_id              = data.aws_ssm_parameter.sg_id.value
  # backend_alb_sg_id = data.aws_ssm_parameter.backend_alb_sg
  health_check_path        = var.component == "frontend" ? "/" : "/health"
  port_number              = var.component == "frontend" ? 80 : 8080
  backend_alb_listener_arn = data.aws_ssm_parameter.backend_alb_listener_arn.value
  frontend_listener_arn    = data.aws_ssm_parameter.frontend_listener_arn.value
  alb_listener_arn         = var.component == "frontend" ? data.aws_ssm_parameter.frontend_listener_arn.value : data.aws_ssm_parameter.backend_alb_listener_arn.value
  host_header              = var.component == "frontend" ? "${var.component}-${var.environment}.${var.domain_name}" : "${var.component}.backend-alb-${var.environment}.${var.domain_name}"

  common_tags = merge(

    {
      "Project"     = var.project_name,
      "Environment" = var.environment,
      Terraform     = "true"
    }
  )
}