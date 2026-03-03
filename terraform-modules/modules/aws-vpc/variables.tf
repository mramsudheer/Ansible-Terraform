# FOR VPC CIDR
variable "vpc_cidr" {
    type = string
    description = "The CIDR Block for VPC"
}
# For PUBLIC SUBNET
variable "public_cidrs"{
    type = list(string)
    description = "List of CIDR blocks for public subnets"
}
# FOR PRIVATE SUBNET
variable "private_cidrs" {
    type = list(string)
    description = "List of CIDR blocks for private subnets"
}
variable "common_tags" {
    type = map(string)
    description = "Common Tags for all resources"
    default = {}
}
variable "project_name" {
    type = string
}
# variable "environment" {
#     type = string
  
# }