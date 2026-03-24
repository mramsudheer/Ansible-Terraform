variable "project_name" {
  type        = string
  description = "Project Name"
}
variable "env" {
  type        = string
  description = "Environment"
}
variable "common_tags" {
  type = map(string)
  default = {
    "Project"   = "Roboshop"
    Environment = "dev"
    Terraform   = "true"
  }
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
variable "instance_type" {
  type = string
}
variable "hosted_zone_id" {
  type = string
}
variable "domain_name" {
  type = string
}
variable "app_version" {
  type    = string
  default = "v3"
}