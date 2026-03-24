# infrastructure-live/dev/us-east-1/frontend-alb/outputs.tf

output "frontend_alb_dns_name" {
  value = aws_lb.frontend_alb.dns_name
}

output "frontend_listener_arn" {
  value = aws_lb_listener.https.arn
}
