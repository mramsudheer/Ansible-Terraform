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
      cidr_blocks = null # Logic in main.tf will swap this for Catalogue/User IDs
      #ALLOW ONLY CATALOGUE
      #source_security_group_id = [module.security_groups["catalogue"].sg_id]
      source_type = "FROM_CATALOGUE"
      description = "Allow Catalogue SG"
      from_port   = 27017
      protocol    = "tcp"
      to_port     = 27017
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Catalogue/User IDs
        #ALLOW ONLY CATALOGUE
        #source_security_group_id = [module.security_groups["catalogue"].sg_id]
        source_type = "FROM_USER"
        description = "Allow User SG"
        from_port   = 27017
        protocol    = "tcp"
        to_port     = 27017
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        #ALLOW ONLY BASTION
        #source_security_group_id = [module.bastion_sg.sg_id]
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  redis = {
    ingress_rules = [{
      cidr_blocks = null # Logic in main.tf will swap this for User and Cart IDs
      source_type = "FROM_CATALOGUE"
      description = "Allow Catalogue SG"
      from_port   = 6379
      protocol    = "tcp"
      to_port     = 6379
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for User and Cart IDs
        source_type = "FROM_USER"
        description = "Allow User SG"
        from_port   = 6379
        protocol    = "tcp"
        to_port     = 6379
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for User and Cart IDs
        source_type = "FROM_CART"
        description = "Allow Cart SG"
        from_port   = 6379
        protocol    = "tcp"
        to_port     = 6379
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  mysql = {
    ingress_rules = [{
      cidr_blocks = null # Logic in main.tf will swap this for shipping ID
      source_type = "FROM_SHIPPING"
      description = "Allow Shipping SG"
      from_port   = 3306
      protocol    = "tcp"
      to_port     = 3306
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  rabbitmq = {
    ingress_rules = [{
      cidr_blocks = null # Logic in main.tf will swap this for Payment ID
      source_type = "FROM_PAYMENT"
      description = "Allow Payment SG"
      from_port   = 5672
      protocol    = "tcp"
      to_port     = 5672
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  # 2. Application Layer
  catalogue = {
    ingress_rules = [{
      #cidr_blocks = ["10.0.0.0/16"]
      cidr_blocks = null
      source_type = "Allow Frontend"
      description = "Allow Frontend SG"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  user = {
    ingress_rules = [{
      #cidr_blocks = ["10.0.0.0/16"]
      cidr_blocks = null
      source_type = "Allow Frontend"
      description = "Allow Frontend SG"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  cart = {
    ingress_rules = [{
      #cidr_blocks = ["10.0.0.0/16"]
      cidr_blocks = null
      source_type = "Allow Frontend"
      description = "Allow Frontend SG"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  shipping = {
    ingress_rules = [{
      #cidr_blocks = ["10.0.0.0/16"]
      cidr_blocks = null
      source_type = "Allow Frontend"
      description = "Allow Frontend SG"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  payment = {
    ingress_rules = [{
      #cidr_blocks = ["10.0.0.0/16"]
      cidr_blocks = null
      source_type = "Allow Frontend"
      description = "Allow Frontend SG"
      from_port   = 8080
      protocol    = "tcp"
      to_port     = 8080
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
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
      source_type = "Allow HTTP"
      description = "Allow HTTP"
      },
      {
        cidr_blocks = null # Logic in main.tf will swap this for Bastion ID
        source_type = "SSH from Bastion"
        description = "Allow Bastion SG"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22

    }]
  }
  bastion = {
    ingress_rules = [{
      #cidr_blocks = ["125.22.115.152/32"] # your IP
      cidr_blocks = ["0.0.0.0/0"] # your IP
      source_type = "SSH from My Home"
      description = "SSH from My Home"
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22
    }]
  }
}