
# Root: wire modules together
locals {
  common_tags = {
    Project       = var.project_name
    X-Environment = var.x_environment
    X-Customer    = var.x_customer
    X-Dept        = var.x_dept
    X-Contact     = var.x_contact
  }
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  tags     = local.common_tags
}

module "network" {
  source               = "./modules/network"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  az                   = var.az
  tags                 = local.common_tags
}

module "security" {
  source               = "./modules/security"
  vpc_id               = module.vpc.vpc_id
  allowed_ssh_cidr     = var.allowed_ssh_cidr
  tags                 = local.common_tags
}

module "compute" {
  source                 = "./modules/compute"
  public_subnet_id       = module.network.public_subnet_id
  private_subnet_id      = module.network.private_subnet_id
  bastion_sg_id          = module.security.bastion_sg_id
  private_sg_id          = module.security.private_sg_id
  key_name               = var.key_name
  bastion_instance_type  = var.bastion_instance_type
  private_instance_type  = var.private_instance_type
  tags                   = local.common_tags
}

# Outputs
output "vpc_id"                  { value = module.vpc.vpc_id }
output "public_subnet_id"       { value = module.network.public_subnet_id }
output "private_subnet_id"      { value = module.network.private_subnet_id }
output "internet_gateway_id"    { value = module.network.internet_gateway_id }
output "nat_gateway_id"         { value = module.network.nat_gateway_id }
output "bastion_public_ip"      { value = module.compute.bastion_public_ip }
output "private_host_private_ip"{ value = module.compute.private_host_private_ip }
