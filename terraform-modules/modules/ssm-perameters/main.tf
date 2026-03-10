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
resource "aws_ssm_parameter" "sg_ids" {
  for_each = var.sg_map

  # This creates the "Box" in AWS Systems Manager
  #name  = "/${var.project_name}/${var.environment}/${each.key}/sg-id"
  name  = "/${title(var.project_name)}/${title(var.environment)}/${title(each.key)}_sg-id"
  type  = "String"
  value = each.value # This puts the 'sg-id' INSIDE the box
}
# data "aws_security_group" "selected" {
#   count = length(var.sg_names)
#   name  = var.sg_names[count.index]
# }
# resource "aws_ssm_parameter" "sg_id" {
#   count = length(var.sg_names)
#   name = "/${var.project_name}/${var.environment}_sg_id"
#   type = "String"
#   value = data.aws_security_group.selected[count.index].id 
# }
# resource "aws_ssm_parameter" "sg_ids" {
#   count = length(var.sg_ids)

#   # unique name for each: e.g. /proj/dev/sg-0, /proj/dev/sg-1
#   name  = "/${var.project_name}/${var.environment}/sg-${count.index}"
#   type  = "String"
#   value = var.sg_ids[count.index]
# }
