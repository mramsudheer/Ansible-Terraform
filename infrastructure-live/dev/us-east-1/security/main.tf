module "security_groups" {
  # Loop through all 10 services
  for_each = var.security_configs
  
  source = "../../../../terraform-modules/modules/sg"

  project_name     = var.project_name
  env              = var.env
  common_tags      = var.common_tags
  
  # Pass the unique component name from the map key (e.g., "mongodb")
  component_name   = each.key 
  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id
  sg_ingress_rules = each.value.ingress_rules
}
