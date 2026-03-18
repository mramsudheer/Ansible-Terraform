resource "aws_route53_record" "catalogue_r53" {
  zone_id         = var.hosted_zone_id
  name            = "catalogue-${var.env}.${var.domain_name}"
  type            = "A"
  ttl             = "1"
  records         = [aws_instance.catalogue_instnace.private_ip]
  allow_overwrite = true

}