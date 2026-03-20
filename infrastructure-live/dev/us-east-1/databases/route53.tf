resource "aws_route53_record" "mongodb_r53" {
  zone_id         = var.hosted_zone_id
  name            = "mongodb-${var.env}.${var.domain_name}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.mongodb_instance.private_ip]
  allow_overwrite = true
}
resource "aws_route53_record" "redis_r53" {
  zone_id         = var.hosted_zone_id
  name            = "redis-${var.env}.${var.domain_name}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.redis_instance.private_ip]
  allow_overwrite = true
}
resource "aws_route53_record" "mysql_r53" {
  zone_id         = var.hosted_zone_id
  name            = "mysql-${var.env}.${var.domain_name}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.mysql_instance.private_ip]
  allow_overwrite = true
}
resource "aws_route53_record" "rabbitmq_r53" {
  zone_id         = var.hosted_zone_id
  name            = "rabbitmq-${var.env}.${var.domain_name}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.rabbitmq_instance.private_ip]
  allow_overwrite = true
}