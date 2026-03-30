module "component" {
  for_each = var.components
  #source = "git::https://github.com/daws-88s/terraform-roboshop-component.git?ref=main"
  source        = "git::https://github.com/mramsudheer/Ansible-Terraform.git//terraform-modules/modules/terraform-roboshop-component?ref=v1.6.0"
  component     = each.key
  rule_priority = each.value.rule_priority
}