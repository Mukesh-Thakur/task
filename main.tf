# main.tf
# Create VPC module if vpc_create flag is true
module "vpc" {
  source = "../test/"
  #version = "4.0.0"
  # Conditionally create the VPC module based on the vpc_create flag
  count = var.vpc_create ? 1 : 0

  name                                 = "${var.stage}-vpc"
  cidr                                 = var.vpc_cidr
  azs                                  = ["us-east-1a", "us-east-1b"]
  enable_nat_gateway                   = var.enable_nat_gateway
  single_nat_gateway                   = var.single_nat_gateway
  enable_vpn_gateway                   = var.enable_vpn_gateway
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  public_dedicated_network_acl         = var.public_dedicated_network_acl
  private_dedicated_network_acl        = var.private_dedicated_network_acl
  public_subnet_names                 = "${var.stage}-public-subnet"
  public_subnets                       = var.public_subnet_cidrs
  private_subnet_names                 = "${var.stage}-private-subnet"
  private_subnets                      = var.private_subnet_cidrs
  public_inbound_acl_rules             = var.public_inbound_acl_rules
  public_outbound_acl_rules            = var.public_outbound_acl_rules
  private_inbound_acl_rules            = var.private_inbound_acl_rules
  private_outbound_acl_rules           = var.private_outbound_acl_rules
  default_route_table_name             = "${var.stage}-route-table"
  manage_default_security_group        = true
  manage_default_security_group_second = true
}

# Create Public Security Group
module "public_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.7.0"
  name        = "${var.stage}-pub-sg"
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

  name        = "${var.stage}-private_sg"
  description = "Security Group with HTTP & SSH port open for entire VPC Block (IPv4 CIDR), egress ports are all world open"
  vpc_id      = module.vpc[0].vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = [module.vpc[0].vpc_cidr_block]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
}
