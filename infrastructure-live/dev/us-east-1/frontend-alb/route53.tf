resource "aws_route53_record" "frontend" {
  zone_id = var.hosted_zone_id
  #name    = "*.${var.domain_name}"
  name = "dev.${var.domain_name}"
  type = "A"

  # load balancer details
  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
  allow_overwrite = true
}
