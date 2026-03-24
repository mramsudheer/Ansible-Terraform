resource "aws_route53_record" "www" {
  #for_each = aws_instance.this # Loops over the actual instances created

  zone_id = var.hosted_zone_id
  name    = "*.backend-alb-${var.env}.${var.domain_name}"
  type    = "A"
  # load balancer details
  alias {
    name                   = aws_alb.backend_alb.dns_name
    zone_id                = aws_alb.backend_alb.zone_id
    evaluate_target_health = true
  }
}
