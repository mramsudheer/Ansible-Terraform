# This "declares" the variable so Terraform knows it exists
variable "project_name" {
  type = string
}
variable "env" {
  type = string
}
variable "common_tags" {
  type = map(string)
}
# variable "component_name" {
#   type = string  
# }
variable "security_configs" {
  type = map(object({
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
      source_type = optional(string)
    }))
  }))
}
