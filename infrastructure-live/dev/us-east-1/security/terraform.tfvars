project_name = "Roboshop"
env          = "Dev"
common_tags = {
  Environment = "dev"
  Terraform   = "true"
  component   = "networking"
}
security_configs = {
  # 1. Database Layer
  mongodb = {
    ingress_rules = [{
      cidr_blocks = ["10.0.0.0/16"] # Only allow traffic from within VPC
      description = "Allow MongoDB port"
      from_port   = 27017
      protocol    = "tcp"
      to_port     = 27017
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  mysql = {
    ingress_rules = [{
      cidr_blocks = ["10.0.0.0/16"] # Only allow traffic from within VPC
      description = "Allow MSQL port"
      from_port   = 3306
      protocol    = "tcp"
      to_port     = 3306
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  redis = {
    ingress_rules = [{
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow REDIS port"
      from_port   = 6379
      protocol    = "tcp"
      to_port     = 6379
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  rabbitmq = {
    ingress_rules = [{
      cidr_blocks = ["10.0.0.0/16"]
      description = "Allow Rabbitmq port"
      from_port   = 5672
      protocol    = "tcp"
      to_port     = 5672
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  # 2. Application Layer
  catalogue = {
    ingress_rules = [{
      cidr_blocks = ["10.0.0.0/16"]
      description = "Catalogue access"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  user = {
    ingress_rules = [{
      cidr_blocks = ["10.0.0.0/16"]
      description = "User Access"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  frontend = {
    ingress_rules = [{
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"] # Public access
      description = "Allow HTTP"
      },
      {
        cidr_blocks = ["10.0.0.0/16"]
        description = "SSH from Bastion"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  bastion = {
    ingress_rules = [{
      #cidr_blocks = ["125.22.115.152/32"] # your IP
      cidr_blocks = ["0.0.0.0/0"] # your IP
      description = "SSH from My Home"
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
    }]
  }
}
