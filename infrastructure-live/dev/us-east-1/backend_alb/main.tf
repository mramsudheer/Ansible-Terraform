# 1. Create the Internal Application Load Balancer
resource "aws_alb" "backend_alb" {
  name               = "${var.project_name}-${var.env}-backend-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  security_groups    = [data.aws_ssm_parameter.backend_alb_sg_id.value]

  # keeping it as false, just to delete using terraform while practice
  enable_deletion_protection = false

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-backend-alb"
  })
}
# 2. Dynamic Target Group for all apps on Port 8080
# resource "aws_alb_target_group" "main" {
#   for_each = toset(["catalogue", "user", "cart", "shipping", "payment", "frontend"])

#   name = "${var.project_name}-${var.env}-${each.key}-tg"
#   port = 8080
#   protocol = "HTTP"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   deregistration_delay = 60

#   health_check {
#     enabled = true
#     interval = 10
#     matcher = "200-299"
#     path = "/health"
#     port = "8080"
#     protocol = "HTTP"
#     timeout = 2
#     unhealthy_threshold = 3
#   }
# }
# 3. HTTP Listener on Port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.backend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "<h1>Hi, I am from HTTP Backend ALB</h1>"
      status_code  = 200
    }
  }
}
resource "aws_ssm_parameter" "backend_listener_arn" {
  name  = "/${title(var.project_name)}/${title(var.env)}/alb/backend_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
  #value = data.terraform_remote_state.alb.outputs.backend_listener_arn
  description = "The ARN of the Backend ALB HTTP Listener"
  overwrite   = true
}

resource "aws_route53_record" "www" {
  zone_id = var.hosted_zone_id
  name    = "*.backend-alb-${var.env}.${var.domain_name}"
  type    = "A"
  
  # load balancer details
  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}