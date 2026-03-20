# resource "aws_route53_record" "catalogue_r53" {
#   zone_id         = var.hosted_zone_id
#   name            = "catalogue-${var.env}.${var.domain_name}"
#   type            = "A"
#   ttl             = "1"
#   records         = [aws_instance.catalogue_instnace.private_ip]
#   allow_overwrite = true
# }
# resource "aws_route53_record" "user_r53" {
#   zone_id         = var.hosted_zone_id
#   name            = "user-${var.env}.${var.domain_name}"
#   type            = "A"
#   ttl             = "1"
#   records         = [aws_instance.user_instance.private_ip]
#   allow_overwrite = true
# }
# resource "aws_route53_record" "cart_r53" {
#   zone_id         = var.hosted_zone_id
#   name            = "cart-${var.env}.${var.domain_name}"
#   type            = "A"
#   ttl             = "1"
#   records         = [aws_instance.cart_instance.private_ip]
#   allow_overwrite = true
# }
resource "aws_route53_record" "apps" {
  for_each = aws_instance.this # Loops over the actual instances created

  zone_id = var.hosted_zone_id
  name    = "${each.key}.${var.domain_name}"
  type    = "A"
  ttl     = 1
  records = [each.value.private_ip]
}
