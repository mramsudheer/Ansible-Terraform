data "aws_ssm_parameter" "vpc_id" {
  name = "/${title(var.project_name)}/${title(var.envinronment)}/vpc/vpc-id"
}
# 2. Fetch Private Subnet IDs from SSM
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${title(var.project_name)}/${title(var.envinronment)}/vpc/private_subnet_ids"
}