output "catalogue_instance_id" {
  value       = aws_instance.catalogue_instnace.id
  description = "catalogue Instance Id"
}
# output "catalogue_public_ip" {
#   value = aws_instance.catalogue_instnace.public_ip
#   description = "catalogue Public IP"
# }
output "catalogue_private_ip" {
  value       = aws_instance.catalogue_instnace.private_ip
  description = "catalogue Private IP"
}
output "catalogue_security_group" {
  #value = aws_instance.catalogue_instnace.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.catalogue_instnace.vpc_security_group_ids)[0])
  description = "catalogue Security Group"
}
output "catalogue_r53_record" {
  description = "catalogue Route53 Record"
  value       = aws_route53_record.catalogue_r53.name
}