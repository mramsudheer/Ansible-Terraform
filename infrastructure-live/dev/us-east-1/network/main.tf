module "vpc" {
  # Relative path to your module logic
  source = "../../../terraform-modules/modules/aws-vpc"

  # Passing values from variables (defined in your tfvars)
  project_name  = var.project_name
  vpc_cidr      = var.vpc_cidr
  public_cidrs  = var.public_cidrs
  private_cidrs = var.private_cidrs
  common_tags   = var.common_tags
}
