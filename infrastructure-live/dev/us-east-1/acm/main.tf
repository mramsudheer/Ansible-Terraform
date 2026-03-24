# 1. Request the Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.domain_name}" # Wildcard covers dev.intellfind.store
  validation_method = "DNS"

  subject_alternative_names = ["${var.domain_name}"] # Also validate the root domain

  tags = merge(var.common_tags, { Name = "${var.project_name}-${var.env}" }, var.common_tags)

  lifecycle {
    create_before_destroy = true
  }
}

# 2. Create the DNS Record for Validation
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id

}

# 3. The "Wait" Resource
# This tells Terraform to wait until AWS confirms the cert is "ISSUED"
resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
