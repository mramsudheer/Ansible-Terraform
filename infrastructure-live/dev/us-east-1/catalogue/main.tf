resource "aws_instance" "catalogue_instnace" {
  ami           = data.aws_ami.custom_ami.id
  instance_type = var.instance_type

  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-catalogue"
  })

}
# For creating User Instance. This is just for testing the security group rules. In real world, we won't create an instance for user. We will use AWS SSM Session Manager to login to the instances in private subnet.
resource "aws_instance" "user_instance" {
  ami           = data.aws_ami.custom_ami.id
  instance_type = var.instance_type

  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  vpc_security_group_ids = [data.aws_ssm_parameter.user_sg_id.value]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-user"
  })
}
# For creating Cart Instance. This is just for testing the security group rules. In real world, we won't create an instance for user. We will use AWS SSM Session Manager to login to the instances in private subnet.
resource "aws_instance" "cart_instance" {
  ami           = data.aws_ami.custom_ami.id
  instance_type = var.instance_type

  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  vpc_security_group_ids = [data.aws_ssm_parameter.cart_sg_id.value]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-cart"
  })
}