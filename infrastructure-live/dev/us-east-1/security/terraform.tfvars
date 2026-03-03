security_configs = {
  mongodb = {
    ingress_rules = [{
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"] # Only allow traffic from within VPC
      description = "Allow MongoDB port"
    }]
  }
  frontend = {
    ingress_rules = [{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Public access
      description = "Allow HTTP"
    }]
  }
}
