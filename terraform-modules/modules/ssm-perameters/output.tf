output "ssm_parameter_names" {
  # Returns the "Box Numbers" (paths) so you can find them later
  value = { for k, v in aws_ssm_parameter.sg_ids : k => v.name }
}

output "ssm_parameter_arns" {
  # Returns the "Legal Deeds" so you can write IAM permissions later
  value = { for k, v in aws_ssm_parameter.sg_ids : k => v.arn }
}
