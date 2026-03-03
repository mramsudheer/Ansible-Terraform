variable "project_name" {
  type        = string
  description = "Project name (e.g., roboshop)"
}

variable "env" {
  type        = string
  description = "Environment (e.g., dev, prod)"
}

variable "component_name" {
  type        = string
  description = "The service name (e.g., mongodb, mysql, shipping)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the SG will be created"
}

variable "common_tags" {
  type        = map(string)
  default     = {}
}

variable "sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  description = "List of ingress rules for this specific component"
  default     = []
}
