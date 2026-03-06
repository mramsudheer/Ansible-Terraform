# FOR VPC CIDR
variable "vpc_cidr" {
  type        = string
  description = "The CIDR Block for VPC"
}
# For PUBLIC SUBNET
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}
# FOR PRIVATE SUBNET
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}
# FOR DATABASE SUBNET
variable "database_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks for database subnets"
}
variable "azs" {
  type        = list(string)
  description = "List of Availability Zones (e.g., ['us-east-1a', 'us-east-1b'])"
}
variable "nat_gateway_enable" {
  type        = bool
  description = "NATGateway required or not"
  default     = false
}
variable "static_ip" {
  type        = string
  description = "Optional: Existing Static IP"
  default     = ""
}
variable "project_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "common_tags" {
  type        = map(string)
  description = "Common Tags for all resources"
  default     = {}
}

