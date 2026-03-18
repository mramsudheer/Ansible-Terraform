# Resource for MongoDB EC2 instance and its dependencies
resource "aws_instance" "mongodb_instance" {
  ami           = data.aws_ami.custom_ami.id
  instance_type = var.instance_type

  subnet_id              = split(",", data.aws_ssm_parameter.database_subnet_ids.value)[0]
  vpc_security_group_ids = [data.aws_ssm_parameter.mongodb_sg_id.value]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.env}-mongodb"
  })
}
resource "terraform_data" "mongodb" {
  triggers_replace = [aws_instance.mongodb_instance.id]

  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb_instance.private_ip
  }
  provisioner "file" {
    source      = "bootstrap.sh"      # Local file path
    destination = "/tmp/bootstrap.sh" # Destination path on the remote machine
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb ${var.env}"
    ]
  }
}