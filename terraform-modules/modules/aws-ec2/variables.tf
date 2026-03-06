variable "ami_id" {
    type = string
    description = "Please give your valid AMI ID"
}
variable "instance_type" {
  type = string
  default = "t3.micro"
  description = "please provide your instance type"
}
variable "subnet_id" {
  type = string
  description = " Please assign the appropriate subnet id"
}
variable "sg_ids" {
  type = list(string)
  description = "Security Groups"
}
variable "project_name" {
  type = string
}
variable "env" {
    type = string  
}
variable "component_name" {
  type = string
}
variable "common_tags" {
  type = map(string)
  default = { 
  }
}