# main.tf
# Create VPC module if vpc_create flag is true
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #version = "4.0.0"
  # Conditionally create the VPC module based on the vpc_create flag
  count = var.vpc_create ? 1 : 0

  name                          = "${var.stage}-vpc"
  cidr                          = var.vpc_cidr
  azs                           = ["us-east-1a", "us-east-1b"]
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_vpn_gateway            = false
  enable_dns_hostnames          = true
  enable_dns_support            = true
  public_dedicated_network_acl  = true #var.public_dedicated_network_acl
  private_dedicated_network_acl = true #var.private_dedicated_network_acl
  public_subnets                = var.public_subnet_cidrs
  private_subnets               = var.private_subnet_cidrs
  public_inbound_acl_rules      = var.public_inbound_acl_rules
  public_outbound_acl_rules     = var.public_outbound_acl_rules
  private_inbound_acl_rules     = var.private_inbound_acl_rules
  private_outbound_acl_rules    = var.private_outbound_acl_rules
}

# Create Public Security Group
module "public_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.7.0"
  name        = "pub-sg"
  description = "Security Group with SSH port open for everybody (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc[0].vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
}

# Create private security group
module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"
  #version = "4.2.0"
  version = "4.7.0"

  name        = "private_sg"
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc[0].vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = [module.vpc[0].vpc_cidr_block]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
}
