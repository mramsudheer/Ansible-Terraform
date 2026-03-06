resource "aws_instance" "this" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.sg_ids

  tags = merge(var.common_tags,{
    Name = "${var.project_name}-${var.env}-${var.component_name}"
  })
}