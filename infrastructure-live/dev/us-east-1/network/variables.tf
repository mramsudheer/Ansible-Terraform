variable "vpc_cidr" {
  type = string
}
variable "public_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "database_subnet_cidrs" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}
variable "nat_gateway_enable" {
  type = bool
}
variable "static_ip" {
  type = bool
}
variable "project_name" {
  type = string
}
variable "environment" {
  type = string

}
variable "common_tags" {
  type = map(string)
}

