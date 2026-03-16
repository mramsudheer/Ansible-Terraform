resource "aws_instance" "bastion" {
  ami           = data.aws_ami.custom_ami.id
  instance_type = var.instance_type

  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-bastion"
  })
}