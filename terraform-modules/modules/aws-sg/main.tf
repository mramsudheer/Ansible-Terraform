resource "aws_security_group" "this" {
    name = "${var.project_name}-${var.env}-${var.component_name}-sg"
    description = "Security Group for ${var.component_name}"
    vpc_id = var.vpc_id
}