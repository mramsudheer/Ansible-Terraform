output "vpc_id" {
  value       = module.vpc.vpc_id # Assuming you use a VPC module
  description = "The ID of the VPC created in the network folder"
}
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "private_subnet_ids" { value = module.vpc.private_subnet_ids }
output "database_subnet_ids" { value = module.vpc.database_subnet_ids }
output "igw_id" { value = module.vpc.igw_id }
output "nat_eip_public_ip" { value = module.vpc.nat_eip_public_ip }
output "nat_gateway_id" { value = module.vpc.nat_gateway_id }