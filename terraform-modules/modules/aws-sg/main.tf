resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.env}-${var.component_name}-sg"
  description = "Security Group for ${var.component_name}"
  vpc_id      = var.vpc_id

  # This allows to have multiple rules(i.e 80, 443, 20...)
  dynamic "ingress" {
    for_each = var.sg_ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      #protocol = "tcp"
      protocol    = ingress.value.protocol
      # cidr_blocks = ingress.value.cidr_blocks
      # description = ingress.value.description
       # Logic: If cidr_blocks is provided, use it. If not, use security_groups.
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      security_groups  = lookup(ingress.value, "source_security_group_id", null)
    }
  }
  # Standard Outbound to allow everything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-${var.component_name}-sg"
  })
}