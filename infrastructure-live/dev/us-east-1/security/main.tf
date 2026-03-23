# 1. TIER 1: BASTION (No dependencies on other SGs)
module "bastion_sg" {
  #source = "../../../../terraform-modules/modules/aws-sg"
  source         = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.7.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = "bastion"
  #vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id # Use remote state for the first call
  vpc_id           = data.aws_ssm_parameter.vpc_id.value
  sg_ingress_rules = var.security_configs["bastion"].ingress_rules
}
# 2. Create the Frontend SG separately
module "frontend_sg" {
  source         = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.7.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = "frontend"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value

  # Frontend usually just needs HTTP/HTTPS and SSH from Bastion
  #sg_ingress_rules = var.security_configs["frontend"].ingress_rules
  sg_ingress_rules = [
    for rule in var.security_configs["frontend"].ingress_rules : merge(rule, {
      source_security_group_id = (
        rule.source_type == "SSH from Bastion" ? [module.bastion_sg.sg_id] :
        rule.source_type == "Allow ALB"        ? [module.frontend_alb_sg.sg_id] : 
        []
      )
      cidr_blocks = rule.source_type != null ? null : rule.cidr_blocks
    })
  ]
}
# 3. Create the Backend_Alb SG separately
module "backend_alb_sg" {
  source         = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.7.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = "backend_alb"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value

  # Backend_ALB usually just needs HTTP/HTTPS and SSH from Bastion
  #sg_ingress_rules = var.security_configs["backend_alb"].ingress_rules
  # ADD THIS LOOP to map the "Allow Frontend" label to the actual ID
  sg_ingress_rules = [
    for rule in var.security_configs["backend_alb"].ingress_rules : merge(rule, {
      source_security_group_id = rule.source_type == "Allow Frontend" ? [module.frontend_sg.sg_id] : []
      cidr_blocks              = rule.source_type != null ? null : rule.cidr_blocks
    })
  ]
}
module "frontend_alb_sg" {
  source         = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.7.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = "frontend-alb"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value

  # These rules use the public CIDRs defined in .tfvars
  sg_ingress_rules = var.security_configs["frontend_alb"].ingress_rules
}
# 3. TIER 2: APP SERVERS (Depends only on Bastion)
# This module is a factory that creates multiple Security Groups (SGs) 
# for application tier (Catalogue, User, etc.) and automatically 
# wires up the connection between them and the Frontend or Bastion.

# The Filter (for_each)
# Instead of writing a module block for every single app, it uses a loop.
# It looks at your security_configs map.
# It filters it to only create SGs for the keys: catalogue, user, shipping, payment, and cart.
# Everything else (like mongodb or bastion) is ignored by this specific block.
module "app_security_groups" {
  # FIX 1: Remove "frontend" from this if condition
  for_each = { for k, v in var.security_configs : k => v
  if k == "catalogue" || k == "user" || k == "shipping" || k == "payment" || k == "cart" }

  source         = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.7.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = each.key
  vpc_id         = data.aws_ssm_parameter.vpc_id.value

  # It takes the rules you defined in terraform.tfvars and replaces your labels 
  # with real AWS IDs using concat(): 
  #SSH Rule: If a rule says "SSH from Bastion", it grabs the ID from module.bastion_sg. 
  # Web Traffic: If a rule says "Allow Frontend", it grabs the ID from module.frontend_sg.
 # The "Safety Net" (The third line in concat): This logic ensures that if the rule is not 
 # for SSH, it automatically allows traffic from the Frontend SG. 
 # This is why your apps (like Catalogue) can talk to the Frontend without you hardcoding IDs.
 # SECURITY GROUPS ARE CREATING IN sg_map IN SSM MODULE.
  sg_ingress_rules = [
    for rule in each.value.ingress_rules : merge(rule, {
      source_security_group_id = concat(
        # Only add Bastion if specifically requested
        rule.source_type == "SSH from Bastion" ? [module.bastion_sg.sg_id] : [],
        rule.source_type == "Allow Frontend" ? [module.frontend_sg.sg_id] : [],
        rule.source_type == "BackEnd ALB"     ? [module.backend_alb_sg.sg_id] : [],
        # FIX: Only add Frontend SG if this is NOT an SSH rule 
        # and NOT the frontend itself
        #(rule.source_type != "SSH from Bastion" && each.key != "Allow Frontend") ? [module.frontend_sg.sg_id] : []
      )

      # Ensure CIDR is null if we added a Security Group ID
      #cidr_blocks = (rule.source_type == "SSH from Bastion" || each.key != "Allow Frontend") ? null : rule.cidr_blocks
      cidr_blocks = rule.source_type != null ? null : rule.cidr_blocks
    })
  ]

}
# 4. TIER 4: DATABASES (Depends on Apps and Bastion)
module "db_security_groups" {
  # Only loop through DBs that need IDs from Tier 2
  for_each = { for k, v in var.security_configs : k => v if k == "mongodb" || k == "mysql" || k == "redis" || k == "rabbitmq" }

  #source = "../../../../terraform-modules/modules/aws-sg"
  source         = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/aws-sg?ref=v0.7.0"
  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = each.key
  #vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  # The following code snippet uses a for expression to dynamically build a list of Security Group 
  # ingress rules. It essentially acts as a "translator" that converts human-friendly labels 
  # into actual AWS resource IDs.
  # If source_type is "SSH from Bastion", it fetches the ID from the bastion module.
  # If it's "FROM_CATALOGUE", "FROM_USER", etc., it looks up the corresponding ID in the app_security_groups map.
  # If no match is found, it returns an empty list [].
  # SECURITY GROUPS ARE CREATING IN sg_map IN SSM MODULE.

  sg_ingress_rules = [
    for rule in each.value.ingress_rules : merge(rule, {
      
      source_security_group_id = rule.source_type == "SSH from Bastion" ? [module.bastion_sg.sg_id] : (
        rule.source_type == "FROM_CATALOGUE" ? [module.app_security_groups["catalogue"].sg_id] :
        rule.source_type == "FROM_USER" ? [module.app_security_groups["user"].sg_id] :
        rule.source_type == "FROM_CART" ? [module.app_security_groups["cart"].sg_id] :
        rule.source_type == "FROM_SHIPPING" ? [module.app_security_groups["shipping"].sg_id] :
        rule.source_type == "FROM_PAYMENT" ? [module.app_security_groups["payment"].sg_id] :
        []
      )
      description = rule.description
      cidr_blocks = rule.source_type != null ? null : rule.cidr_blocks
    })
  ]
}
# This creates the "backend_alb_catalogue" type rules dynamically for all apps
resource "aws_security_group_rule" "backend_alb_to_apps" {
  for_each = module.app_security_groups

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Allow traffic from ${each.key} ALB"
  security_group_id        = module.backend_alb_sg.sg_id
  source_security_group_id = each.value.sg_id
}
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
  sg_map = merge(
    { "bastion" = module.bastion_sg.sg_id },
    { "frontend" = module.frontend_sg.sg_id },
    { "backend_alb" = module.backend_alb_sg.sg_id },
    { for name, instance in module.app_security_groups : name => instance.sg_id },
    { for name, instance in module.db_security_groups : name => instance.sg_id }
  )
}