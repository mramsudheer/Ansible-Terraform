# module "security_groups" {
#   # Loop through all 10 services
#   for_each = var.security_configs

#   source = "../../../../terraform-modules/modules/sg"

#   project_name     = var.project_name
#   env              = var.env
#   common_tags      = var.common_tags

#   # Pass the unique component name from the map key (e.g., "mongodb")
#   component_name   = each.key 
#   vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
#   sg_ingress_rules = each.value.ingress_rules
# }
# module "ssm" {
#   source       = "../../../../terraform-modules/modules/ssm-perameters"
#   project_name = var.project_name
#   environment  = var.env

#   # Connecting the modules
#   vpc_id              = module.vpc.vpc_id
#   public_subnet_ids   = module.vpc.public_subnet_ids
#   private_subnet_ids  = module.vpc.private_subnet_ids
#   database_subnet_ids = module.vpc.database_subnet_ids
#   igw_id              = module.vpc.igw_id
#   nat_eip_public_ip   = module.vpc.nat_eip_public_ip
#   nat_gateway_id      = module.vpc.nat_gateway_id
#   sg_map = { for name, instance in module.security_groups : name => instance.sg_id }
# }

# 1. CREATE THE BASTION SECURITY GROUP FIRST
# We create this separately so we have its ID available for the other servers
module "bastion_sg" {
  source = "../../../../terraform-modules/modules/aws-sg"

  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = "bastion"
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id

  # Pulls the ingress rules specifically for bastion from your .tfvars
  sg_ingress_rules = var.security_configs["bastion"].ingress_rules
}

# 2. CREATE THE OTHER 10 SECURITY GROUPS
module "security_groups" {
  # We filter out "bastion" from the loop because it was created above
  for_each = { for k, v in var.security_configs : k => v if k != "bastion" }

  source = "../../../../terraform-modules/modules/aws-sg"

  project_name   = var.project_name
  env            = var.env
  common_tags    = var.common_tags
  component_name = each.key
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id

  # DYNAMIC LOGIC: If a rule is for Port 22, use Bastion SG ID as source instead of CIDR
  # sg_ingress_rules = [
  #   for rule in each.value.ingress_rules : merge(rule, {
  #     source_security_group_id = rule.from_port == 22 ? module.bastion_sg.sg_id : null
  #     cidr_blocks              = rule.from_port == 22 ? null : rule.cidr_blocks
  #   })
  # ]
  sg_ingress_rules = [
    for rule in each.value.ingress_rules : merge(rule, {
      # Wrap the ID in [ ] to make it a list
      source_security_group_id = rule.from_port == 22 ? [module.bastion_sg.sg_id] : []

      # Ensure cidr_blocks is also handled correctly
      cidr_blocks = rule.from_port == 22 ? null : rule.cidr_blocks
    })
  ]
}

# 3. STORE EVERYTHING IN SSM
module "ssm" {
  source       = "../../../../terraform-modules/modules/ssm-perameters"
  project_name = var.project_name
  environment  = var.env

  # Pulling from the REMOTE 'network' folder via data.tf
  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids   = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  private_subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  database_subnet_ids = data.terraform_remote_state.vpc.outputs.database_subnet_ids
  igw_id              = data.terraform_remote_state.vpc.outputs.igw_id
  nat_eip_public_ip   = data.terraform_remote_state.vpc.outputs.nat_eip_public_ip
  nat_gateway_id      = data.terraform_remote_state.vpc.outputs.nat_gateway_id

  # MERGE: Combine the Bastion ID and the looped IDs into one final map for SSM
  sg_map = merge(
    { "bastion" = module.bastion_sg.sg_id },
    { for name, instance in module.security_groups : name => instance.sg_id }
  )
}
