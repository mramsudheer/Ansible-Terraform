# resource "aws_instance" "catalogue_instnace" {
#   ami           = data.aws_ami.custom_ami.id
#   instance_type = var.instance_type

#   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
#   vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.env}-catalogue"
#   })

# }
# # For creating User Instance. This is just for testing the security group rules. In real world, we won't create an instance for user. We will use AWS SSM Session Manager to login to the instances in private subnet.
# resource "aws_instance" "user_instance" {
#   ami           = data.aws_ami.custom_ami.id
#   instance_type = var.instance_type

#   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
#   vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.env}-user"
#   })
# }
# # For creating Cart Instance. This is just for testing the security group rules. In real world, we won't create an instance for user. We will use AWS SSM Session Manager to login to the instances in private subnet.
# resource "aws_instance" "cart_instance" {
#   ami           = data.aws_ami.custom_ami.id
#   instance_type = var.instance_type

#   subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
#   vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]

#   tags = merge(var.common_tags, {
#     Name = "${var.project_name}-${var.env}-cart"
#   })
# }
resource "aws_instance" "this" {
  for_each = toset(var.apps)

  ami           = data.aws_ami.custom_ami.id
  instance_type = var.instance_type
  subnet_id     = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]

  # Fetches the SG ID from the automated data block above
  vpc_security_group_ids = [data.aws_ssm_parameter.app_sgs[each.key].value]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-${each.key}"
  })
}
# Target Groups for all Apps
resource "aws_alb_target_group" "main" {
  for_each = toset(local.apps)

  name = "${var.project_name}-${var.env}-${each.key}"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  deregistration_delay = 60

  health_check {
    healthy_threshold = 2
    interval = 10
    matcher = "200-299"
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 2
    unhealthy_threshold = 3
  }
}
# Launch Templates for all Apps
resource "aws_launch_template" "main" {
  for_each = toset(local.apps)

  name = "${var.project_name}-${var.env}-${each.key}"
  image_id = data.aws_ami.custom_ami.id

  # once autoscaling sees less traffic, it will terminate the instance
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type

  # Pulls the specific SG ID for this app from the data source above
  vpc_security_group_ids = [data.aws_ssm_parameter.app_sgs[each.key].value]

   # each time we apply terraform this version will be updated as default
  update_default_version = true

  # tags for instances created by launch template through autoscaling
  tag_specifications {
    resource_type = "instance"

    tags = merge(
        {
            Name = "${var.project_name}-${var.env}-${each.key}"
        },
        var.common_tags
    )
  }
  # tags for volumes created by instances
  tag_specifications {
    resource_type = "volume"

    tags = merge(
        {
            Name = "${var.project_name}-${var.env}-${each.key}"
        },
        var.common_tags
    )
  }
  # tags for launch template
  tags = merge(
        {
            Name = "${var.project_name}-${var.env}-${each.key}"
        },
        var.common_tags
    )

}
# Auto Scaling Groups for all Apps
resource "aws_autoscaling_group" "main" {
  for_each = toset(local.apps)

  name = "${var.project_name}-${var.env}-${each.key}"
  max_size = 10
  min_size = 1
  health_check_grace_period = 120
  health_check_type = "ELB"
  desired_capacity = 1
  vpc_zone_identifier = split(",", data.aws_ssm_parameter.private_subnet_ids.value)

  launch_template {
    id = aws_launch_template.main[each.key].id
    version = "$Latest"
  }
  target_group_arns = [aws_alb_target_group.main[each.key].arn]

  dynamic "tag" {
    for_each = merge(
        {
            Name = "${var.project_name}-${var.env}-${each.key}"
        },
        var.common_tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  # with in 15min autoscaling should be successful
  timeouts {
    delete = "15m"
  }
}
# ALB Listener Rules for all Apps
resource "aws_lb_listener_rule" "main" {
  for_each = toset(local.apps)
  listener_arn = data.aws_ssm_parameter.backend_listener_arn.value
  # Assigns unique priorities: 10, 11, 12, 13, 14
  priority     = 10 + index(local.apps, each.key)
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[each.key].arn
  }
  condition {
    host_header {
      values = ["${each.key}.${lower(var.env)}.${var.domain_name}"]
    }
  }
}
# 5. Create Auto Scaling Policies for all Apps
resource "aws_autoscaling_policy" "cpu_scaling" {
  for_each = toset(local.apps)

  name                   = "${var.project_name}-${var.env}-${each.key}-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.main[each.key].name
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}