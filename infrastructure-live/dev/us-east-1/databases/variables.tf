variable "project_name" {
  type = string
  description = "Project Name"
}
variable "env" {
  type = string
}
variable "instance_type" {
type = string
}
variable "common_tags" {
  type = map(string)
  default = {}
}
variable "ami_id" {
  type = string
}
variable "region" {
  type = string
}
variable "owner_id" {
  type = string
}
variable "ami_name" {
  type = string
}
variable "hosted_zone_id" {
  type = string
}
variable "hosted_zone_name" {
  type = string
}
variable "domain_name" {
    type = string
}