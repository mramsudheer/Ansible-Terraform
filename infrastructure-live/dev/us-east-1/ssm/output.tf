output "ssm_parameter_arns" {
  description = "The ARNs of the SSM parameters where IDs are stored"
  value       = module.ssm.ssm_parameter_arns
}
