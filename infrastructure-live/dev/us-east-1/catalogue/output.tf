# FOR CATALOGUE
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
#FOR USER
output "user_instance_id" {
  value       = aws_instance.user_instance.id
  description = "user Instance Id"
}
output "user_private_ip" {
  value       = aws_instance.user_instance.private_ip
  description = "user Private IP"
}
output "user_security_group" {
  #value = aws_instance.user_instance.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.user_instance.vpc_security_group_ids)[0])
  description = "user Security Group"
}
output "user_r53_record" {
  description = "user Route53 Record"
  value       = aws_route53_record.user_r53.name
}
#FOR CART
output "cart_instance_id" {
  value       = aws_instance.cart_instance.id
  description = "cart Instance Id"
}
output "cart_private_ip" {
  value       = aws_instance.cart_instance.private_ip
  description = "cart Private IP"
}
output "cart_security_group" {
  #value = aws_instance.cart_instance.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.cart_instance.vpc_security_group_ids)[0])
  description = "cart Security Group"
}
output "cart_r53_record" {
  description = "cart Route53 Record"
  value       = aws_route53_record.cart_r53.name
}