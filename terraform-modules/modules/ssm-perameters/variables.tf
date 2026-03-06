variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "database_subnet_ids" {
  type = list(string)
}
variable "igw_id" {
  type = string
}
variable "project_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "nat_gateway_id" {
  type    = string
  default = ""
}
variable "nat_eip_public_ip" {
  type    = string
  default = ""
}
