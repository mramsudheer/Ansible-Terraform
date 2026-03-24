resource "aws_lb" "frontend_alb" {
  name               = "${var.project_name}-${var.env}-frontend"
  internal           = false # PUBLIC
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.frontend_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  # keeping it as false, just to delete using terraform while practice
  enable_deletion_protection = false

  tags = merge({ Name = "${var.project_name}-${var.env}-frontend" }, var.common_tags)
}

# 1. HTTP Listener (Port 80) - Redirects to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# 2. HTTPS Listener (Port 443) - Secure Entry
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_ssm_parameter.acm_certificate_arn.value

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "<h1>Hi, I am from HTTPS Frontend ALB. Welcome to Roboshop Secure Frontend</h1>"
      status_code  = "200"
    }
  }
}

# SELF-CLEANING PARAMETER: Stored here so it dies when the ALB is destroyed
resource "aws_ssm_parameter" "frontend_listener_arn" {
  name  = "/${title(var.project_name)}/${title(var.env)}/alb/frontend_listener_arn"
  type  = "String"
  value = aws_lb_listener.https.arn # Point to the HTTPS listener for the apps
}
