module "vpc" {
  # Relative path to your module logic
  source = "../../../../terraform-modules/modules/aws-vpc"

  # Passing values from variables (defined in your tfvars)

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  azs                   = var.azs
  nat_gateway_enable    = var.nat_gateway_enable
  static_ip             = var.static_ip
  project_name          = var.project_name
  common_tags           = var.common_tags
  environment           = var.environment
}
module "ssm" {
  source       = "../../../../terraform-modules/modules/ssm-perameters"
  project_name = var.project_name
  environment  = var.environment

  # Connecting the modules
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  database_subnet_ids = module.vpc.database_subnet_ids
  igw_id              = module.vpc.igw_id
  nat_eip_public_ip   = module.vpc.nat_eip_public_ip
  nat_gateway_id      = module.vpc.nat_gateway_id
  #sg_map = { for name, instance in module.security_groups : name => instance.sg_id }
}