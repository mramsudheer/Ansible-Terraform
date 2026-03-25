# FOR VPC CIDR
# variable "vpc_cidr" {
#   type        = string
#   description = "The CIDR Block for VPC"
# }
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
# variable "region" {
#   type = string
# }
variable "owner_id" {
  type = string
  default = "973714476881"
}
variable "ami_name" {
  type = string
  default = "Redhat-9-DevOps-Practice"
}
# For PUBLIC SUBNET
# variable "public_subnet_cidrs" {
#   type        = list(string)
#   description = "List of CIDR blocks for public subnets"
# }
# FOR PRIVATE SUBNET
# variable "private_subnet_ids" {
#   type        = list(string)
#   description = "List of private subnet IDs"
# }
# FOR DATABASE SUBNET
# variable "database_subnet_cidrs" {
#   type        = list(string)
#   description = "List of CIDR blocks for database subnets"
# }
# variable "azs" {
#   type        = list(string)
#   description = "List of Availability Zones (e.g., ['us-east-1a', 'us-east-1b'])"
# }
# variable "nat_gateway_enable" {
#   type        = bool
#   description = "NATGateway required or not"
#   default     = false
# }
# variable "static_ip" {
#   type        = string
#   description = "Optional: Existing Static IP"
#   default     = ""
# }
variable "project_name" {
  type = string
  default = "Roboshop"
}
variable "environment" {
  type = string
  default = "Dev"
}
variable "common_tags" {
  type        = map(string)
  description = "Common Tags for all resources"
  default     = {}
}
variable "component" {
  type = string
}
variable "app_version" {
  type    = string
  default = "v3"
}
variable "rule_priority" {
  type = number
}
variable "domain_name" {
  type = string
  default = "intellifind.store"
}

variable "hosted_zone_id" {
  type = string
  default = "Z0966494EBSLUZZZRGB4"
}
# variable "hosted_zone_name" {
#   type = string
# }