output "bastion_instance_id" {
  value       = aws_instance.bastion.id
  description = "Bastion Instance Id"
}
output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Bastion Public IP"
}
output "bastion_private_ip" {
  value       = aws_instance.bastion.private_ip
  description = "Bastion Private IP"
}
output "bastion_security_group" {
  #value = aws_instance.bastion.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.bastion.vpc_security_group_ids)[0])
  description = "Bastion Security Group"
}