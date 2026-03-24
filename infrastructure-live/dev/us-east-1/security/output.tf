output "security_group_ids" {
  description = "Map of all 11 security group IDs created"
  # This creates: { "mongodb" = "sg-123", "frontend" = "sg-456", ... }
  #value = { for name, instance in module.security_groups : name => instance.sg_id }
  value = merge(
    { "bastion" = module.bastion_sg.sg_id },
    { "frontend" = module.frontend_sg.sg_id },
    { "backend_alb" = module.backend_alb_sg.sg_id },
     { "frontend_alb" = module.frontend_alb_sg.sg_id },
    { for name, instance in module.app_security_groups : name => instance.sg_id },
    { for name, instance in module.db_security_groups : name => instance.sg_id }
  )
}

# output "ssm_parameter_arns" {
#   description = "The ARNs of the SSM parameters where IDs are stored"
#   value       = module.ssm.ssm_parameter_arns
# }
