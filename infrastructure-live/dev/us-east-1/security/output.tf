output "security_group_ids" {
  description = "Map of all 11 security group IDs created"
  # This creates: { "mongodb" = "sg-123", "frontend" = "sg-456", ... }
  value = { for name, instance in module.security_groups : name => instance.sg_id }
}

output "ssm_parameter_arns" {
  description = "The ARNs of the SSM parameters where IDs are stored"
  value       = module.ssm.ssm_parameter_arns
}
