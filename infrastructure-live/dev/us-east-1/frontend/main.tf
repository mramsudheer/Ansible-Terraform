# resource "aws_instance" "frontend_instance" {
#   ami           = data.aws_ami.custom_ami.id
#   instance_type = var.instance_type

#   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
#   vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.env}-catalogue"
#   })

# }
# 1. Target Group (Frontend Nginx listens on 80)
resource "aws_lb_target_group" "frontend" {
  name     = "${var.project_name}-${var.env}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    path     = "/"
    port     = "80"
    protocol = "HTTP"
    matcher  = "200"
  }
}

# 2. Launch Template (The Blueprint)
resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.project_name}-${var.env}-frontend"
  image_id      = data.aws_ami.custom_ami.id
  instance_type = var.instance_type

  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.common_tags, { Name = "frontend" })
  }
}

# 3. Auto Scaling Group (The Instance Creator)
resource "aws_autoscaling_group" "frontend" {
  name                = "${var.project_name}-${var.env}-frontend-asg"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  target_group_arns   = [aws_lb_target_group.frontend.arn]

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }
}

# 4. Listener Rule (Plugs the ASG into the Public HTTPS Listener)
resource "aws_lb_listener_rule" "frontend" {
  listener_arn = data.aws_ssm_parameter.frontend_listener_arn.value
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["dev.${var.domain_name}","frontend-dev.${var.domain_name}"]
    }
  }
}

# 1. Wait for the ASG to launch at least one instance
data "aws_instances" "frontend" {
  instance_tags = {
    Name = "frontend"
  }
  instance_state_names = ["running"]

  # This ensures we don't try to connect before the instance exists
  depends_on = [aws_autoscaling_group.frontend]
}
resource "time_sleep" "wait_for_instance" {
  depends_on = [aws_autoscaling_group.frontend]
  create_duration = "90s"
}
# 2. Use terraform_data to push the script
resource "terraform_data" "frontend" {
     depends_on = [time_sleep.wait_for_instance] 
  triggers_replace = [
    aws_launch_template.frontend.id
  ]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    # Use the FIRST private IP found by the data source
    host = data.aws_instances.frontend.private_ips[0]
  }

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh frontend ${var.env} ${var.app_version}"
    ]
  }
}
