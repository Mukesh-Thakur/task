# main.tf
# Create VPC module if vpc_create flag is true
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # Conditionally create the VPC module based on the vpc_create flag
  count  = var.vpc_create ? 1 : 0

  name                 = "${var.stage}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_public_subnet = true
  create_private_subnet = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}
# Create public security group
module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.stage}-public-sg"
  description = "Public security group"
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Add more ingress rules as needed
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Add more egress rules as needed
  ]
}

# Create private security group
module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.stage}-private-sg"
  description = "Private security group"
  vpc_id      = var.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]  # Replace with the CIDR block of your VPC
    },
    # Add more ingress rules as needed
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    # Add more egress rules as needed
  ]
}

# Create public network ACL
module "public_nacl" {
  source  = "terraform-aws-modules/acl/aws"
  version = "2.1.0"

  name        = "${var.stage}-public-nacl"
  vpc_id      = var.vpc_id
  subnet_ids  = []  # Add the IDs of public subnets associated with this network ACL

  # Ingress rules
  ingress = [
    {
      rule_number   = 100
      protocol      = "tcp"
      rule_action   = "allow"
      cidr_block    = "0.0.0.0/0"
      from_port     = 80
      to_port       = 80
    },
    # Add more ingress rules as needed
  ]

  # Egress rules
  egress = [
    {
      rule_number   = 100
      protocol      = "tcp"
      rule_action   = "allow"
      cidr_block    = "0.0.0.0/0"
      from_port     = 0
      to_port       = 65535
    },
    # Add more egress rules as needed
  ]
}

# Create private network ACL
module "private_nacl" {
  source  = "terraform-aws-modules/acl/aws"
  version = "2.1.0"

  name        = "${var.stage}-private-nacl"
  vpc_id      = var.vpc_id
  subnet_ids  = []  # Add the IDs of private subnets associated with this network ACL

  # Ingress rules
  ingress = [
    {
      rule_number   = 100
      protocol      = "tcp"
      rule_action   = "allow"
      cidr_block    = "10.0.0.0/16"  # Replace with the CIDR block of your VPC
      from_port     = 22
      to_port       = 22
    },
    # Add more ingress rules as needed
  ]

  # Egress rules
  egress = [
    {
      rule_number   = 100
      protocol      = "tcp"
      rule_action   = "allow"
      cidr_block    = "0.0.0.0/0"
      from_port     = 0
      to_port       = 65535
    },
    # Add more egress rules as needed
  ]
}
