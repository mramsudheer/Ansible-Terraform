output "mongodb_instance_id" {
  value       = aws_instance.mongodb_instance.id
  description = "mongodb Instance Id"
}
# output "mongodb_public_ip" {
#   value = aws_instance.mongodb.public_ip
#   description = "mongodb Public IP"
# }
output "mongodb_private_ip" {
  value       = aws_instance.mongodb_instance.private_ip
  description = "mongodb Private IP"
}
output "mongodb_security_group" {
  #value = aws_instance.mongodb.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.mongodb_instance.vpc_security_group_ids)[0])
  description = "mongodb Security Group"
}
output "mongodb_r53_record" {
  value       = aws_route53_record.mongodb_r53.name
  description = "mongodb Route53 Record"

}