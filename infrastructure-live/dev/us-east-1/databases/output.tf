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
# FOR REDIS
output "redis_instance_id" {
  value       = aws_instance.redis_instance.id
  description = "redis Instance Id"
}

output "redis_private_ip" {
  value       = aws_instance.redis_instance.private_ip
  description = "redis Private IP"
}
output "redis_security_group" {
  #value = aws_instance.redis.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.redis_instance.vpc_security_group_ids)[0])
  description = "redis Security Group"
}
output "redis_r53_record" {
  value       = aws_route53_record.redis_r53.name
  description = "redis Route53 Record"
}
# FOR MYSQL
output "mysql_instance_id" {
  value       = aws_instance.mysql_instance.id
  description = "mysql Instance Id"
}

output "mysql_private_ip" {
  value       = aws_instance.mysql_instance.private_ip
  description = "mysql Private IP"
}
output "mysql_security_group" {
  #value = aws_instance.mysql.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.mysql_instance.vpc_security_group_ids)[0])
  description = "mysql Security Group"
}
output "mysql_r53_record" {
  value       = aws_route53_record.mysql_r53.name
  description = "mysql Route53 Record"
}
# FOR RABBITMQ
output "rabbitmq_instance_id" {
  value       = aws_instance.rabbitmq_instance.id
  description = "rabbitmq Instance Id"
}

output "rabbitmq_private_ip" {
  value       = aws_instance.rabbitmq_instance.private_ip
  description = "rabbitmq Private IP"
}
output "rabbitmq_security_group" {
  #value = aws_instance.rabbitmq.vpc_security_group_ids
  value       = nonsensitive(tolist(aws_instance.rabbitmq_instance.vpc_security_group_ids)[0])
  description = "rabbitmq Security Group"
}
output "rabbitmq_r53_record" {
  value       = aws_route53_record.rabbitmq_r53.name
  description = "rabbitmq Route53 Record"
}