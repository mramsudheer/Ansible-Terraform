# 1. TIER 1: BASTION (No dependencies on other SGs)
module "bastion_sg" {
  #source = "../../../../terraform-modules/modules/aws-sg"
   source = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.1.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = "bastion"
  #vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id # Use remote state for the first call
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_ingress_rules = var.security_configs["bastion"].ingress_rules
}

# 2. TIER 2: APP SERVERS (Depends only on Bastion)
module "app_security_groups" {
  # Only loop through apps that don't depend on other internal SGs
  for_each = { for k, v in var.security_configs : k => v if k == "catalogue" || k == "user" || k == "frontend" || k == "shipping" || k == "payment" || k == "cart" }

  #source = "../../../../terraform-modules/modules/aws-sg"
   source = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.1.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = each.key
  #vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  sg_ingress_rules = [
    for rule in each.value.ingress_rules : merge(rule, {
      # If source_type is "SSH from Bastion", use the Bastion ID
      source_security_group_id = rule.source_type == "SSH from Bastion" ? [module.bastion_sg.sg_id] : []
      cidr_blocks              = rule.source_type == "SSH from Bastion" ? null : rule.cidr_blocks
    })
  ]
}

# 3. TIER 3: DATABASES (Depends on Apps and Bastion)
module "db_security_groups" {
  # Only loop through DBs that need IDs from Tier 2
  for_each = { for k, v in var.security_configs : k => v if k == "mongodb" || k == "mysql" || k == "redis" || k == "rabbitmq" }

  #source = "../../../../terraform-modules/modules/aws-sg"
   source = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.1.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = each.key
  #vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  sg_ingress_rules = [
    for rule in each.value.ingress_rules : merge(rule, {
      # LOGIC:
      # If SSH -> Bastion
      # If MongoDB -> Catalogue + User
      # source_security_group_id = rule.source_type == "SSH from Bastion" ? [module.bastion_sg.sg_id] : (
      #   rule.source_type == "Allow MongoDB port" ? [
      #     module.app_security_groups["catalogue"].sg_id,
      #     module.app_security_groups["user"].sg_id
      #   ] : []
      # )
      source_security_group_id = rule.source_type == "SSH from Bastion" ? [module.bastion_sg.sg_id] : (
                                 rule.source_type == "FROM_CATALOGUE"    ? [module.app_security_groups["catalogue"].sg_id] :
                                 rule.source_type == "FROM_USER"         ? [module.app_security_groups["user"].sg_id] : 
                                 []
                               )
      description = rule.description
      cidr_blocks = rule.source_type != null ? null : rule.cidr_blocks
    })
  ]
}

# 4. STORE EVERYTHING IN SSM
module "ssm" {
  source       = "../../../../terraform-modules/modules/ssm-perameters"
  project_name = var.project_name
  environment  = var.env

  # Use .value directly (don't split here, keep the whole string/list)
  vpc_id              = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids   = split(",",data.aws_ssm_parameter.public_subnet_ids.value)
  private_subnet_ids  = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  database_subnet_ids = split(",",data.aws_ssm_parameter.database_subnet_ids.value)
  
  #igw_id              = data.aws_ssm_parameter.igw_id.value
  #nat_eip_public_ip   = data.aws_ssm_parameter.nat_eip_public_ip.value
  
  # ERROR FIX: Changed .id to .value
  #nat_gateway_id      = data.aws_ssm_parameter.nat_gateway_id.value

  # Use the ID from the IGW search
  igw_id = data.aws_internet_gateway.default.internet_gateway_id
  # Logic: If the list of NAT Gateways is not empty, take the first one. Otherwise, ""
  nat_gateway_id = length(data.aws_nat_gateways.all.ids) > 0 ? data.aws_nat_gateways.all.ids[0] : ""
  # If a NAT Gateway was found, get its public IP. Otherwise, send empty string.
  nat_eip_public_ip = length(data.aws_nat_gateways.all.ids) > 0 ? data.aws_nat_gateway.selected[0].public_ip : ""

  # Combine all 3 modules into one map
  sg_map = merge(
    { "bastion" = module.bastion_sg.sg_id },
    { for name, instance in module.app_security_groups : name => instance.sg_id },
    { for name, instance in module.db_security_groups : name => instance.sg_id }
  )
}

# module "ssm" {
#   source       = "../../../../terraform-modules/modules/ssm-perameters"
#   project_name = var.project_name
#   environment  = var.env

#   #vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
#   #public_subnet_ids   = data.terraform_remote_state.vpc.outputs.public_subnet_ids
#   #private_subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnet_ids
#   #database_subnet_ids = data.terraform_remote_state.vpc.outputs.database_subnet_ids
#   #igw_id              = data.terraform_remote_state.vpc.outputs.igw_id
#   #nat_eip_public_ip   = data.terraform_remote_state.vpc.outputs.nat_eip_public_ip
#   #nat_gateway_id      = data.terraform_remote_state.vpc.outputs.nat_gateway_id
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   public_subnet_ids =split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
#   private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_ids.value)[0]
#   database_subnet_ids = split(",",data.aws_ssm_parameter.database_subnet_ids.value)[0]
#   igw_id = data.aws_ssm_parameter.igw_id.value
#   nat_eip_public_ip = data.aws_ssm_parameter.nat_eip_public_ip.value
#   nat_gateway_id = data.aws_ssm_parameter.nat_gateway_id.id
#   # Combine all 3 modules into one map for SSM
#   sg_map = merge(
#     { "bastion" = module.bastion_sg.sg_id },
#     { for name, instance in module.app_security_groups : name => instance.sg_id },
#     { for name, instance in module.db_security_groups : name => instance.sg_id }
#   )
# }
