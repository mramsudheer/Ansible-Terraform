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
variable "hosted_zone_id" {
  type = string
}
# variable "hosted_zone_name" {
#   type = string
# }
variable "domain_name" {
  type = string
}