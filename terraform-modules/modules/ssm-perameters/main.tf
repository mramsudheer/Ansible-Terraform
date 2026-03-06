resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc/vpc-id"
  type  = "String"
  value = var.vpc_id
}
resource "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/vpc/public_subnet_ids"
  type = "StringList"
  # Join the list into a comma-separated string for SSM
  value = join(",", var.public_subnet_ids)
}
resource "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/vpc/private_subnet_ids"
  type = "StringList"
  # Join the list into a comma-separated string for SSM
  value = join(",", var.private_subnet_ids)
}
resource "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/vpc/database_subnet_ids"
  type = "StringList"
  # Join the list into a comma-separated string for SSM
  value = join(",", var.database_subnet_ids)
}
resource "aws_ssm_parameter" "nat_gateway_id" {
  count = var.nat_gateway_id != "" ? 1 : 0
  name  = "/${var.project_name}/${var.environment}/vpc/nat_gateway_id"
  type  = "String"
  # Join the list into a comma-separated string for SSM
  value = join(",", var.database_subnet_ids)
}
resource "aws_ssm_parameter" "nat_eip" {
  # Logic: If the IP is empty, count is 0 (skips creation)
  count = var.nat_eip_public_ip != "" ? 1 : 0

  name  = "/${var.project_name}/${var.environment}/vpc/nat_eip_public_ip"
  type  = "String"
  value = var.nat_eip_public_ip
}

