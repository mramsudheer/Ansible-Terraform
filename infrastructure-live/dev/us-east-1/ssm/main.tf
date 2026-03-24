# 5. STORE EVERYTHING IN SSM
module "ssm" {
  source       = "../../../../terraform-modules/modules/ssm-perameters"
  project_name = var.project_name
  environment  = var.env

  # Use .value directly (don't split here, keep the whole string/list)
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids   = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  private_subnet_ids  = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  database_subnet_ids = split(",", data.aws_ssm_parameter.database_subnet_ids.value)

  # Use the ID from the IGW search
  igw_id = data.aws_internet_gateway.default.internet_gateway_id
  # Logic: If the list of NAT Gateways is not empty, take the first one. Otherwise, ""
  nat_gateway_id = length(data.aws_nat_gateways.all.ids) > 0 ? data.aws_nat_gateways.all.ids[0] : ""
  # If a NAT Gateway was found, get its public IP. Otherwise, send empty string.
  nat_eip_public_ip = length(data.aws_nat_gateways.all.ids) > 0 ? data.aws_nat_gateway.selected[0].public_ip : ""

  # Combine all 3 modules into one map and stores in SSM. 
  # SSM code(resource "aws_ssm_parameter" "sg_ids" {}) is in SSM-perameters module. 
  # sg_map = merge(
  #   { "bastion" = module.bastion_sg.sg_id },
  #   { "frontend" = module.frontend_sg.sg_id },
  #   { "backend_alb" = module.backend_alb_sg.sg_id },
  #   { for name, instance in module.app_security_groups : name => instance.sg_id },
  #   { for name, instance in module.db_security_groups : name => instance.sg_id }
  # )
}