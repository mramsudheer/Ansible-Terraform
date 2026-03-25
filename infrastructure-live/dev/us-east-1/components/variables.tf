# FOR VPC CIDR
variable "vpc_cidr" {
  type        = string
  description = "The CIDR Block for VPC"
}
# variable "ami_id" {
#   type = string
# }
# variable "instance_type" {
#   type    = string
#   default = "t3.micro"
# }
variable "region" {
  type = string
}
variable "owner_id" {
  type = string
}
variable "ami_name" {
  type = string
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}
variable "project_name" {
  type = string
  default = "Roboshop"
}
variable "envinronment" {
  type = string
}
# variable "common_tags" {
#   type        = map(string)
#   description = "Common Tags for all resources"
#   default     = {}
# }
variable "domain_name" {
    type = string
  default = "intellifind.store"
}

variable "hosted_zone_id" {
  type = string
}
variable "components" {
  default = {
    # backend components are attaching to backend ALB
    catalogue = {
      rule_priority = 10
    }
    # user = {
    #     rule_priority = 20
    # }
    # cart = {
    #     rule_priority = 30
    # }
    # shipping = {
    #     rule_priority = 40
    # }
    # payment = {
    #     rule_priority = 50
    # }
    # # this is attaching to frontend ALB, there is only component there
    # frontend = {
    #     rule_priority = 10
    # }
  }
}