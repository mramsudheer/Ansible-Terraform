variable "project_name" {
  type = string
}
variable "env" {
  type = string
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "common_tags" {
  type    = map(string)
  default = {}
}