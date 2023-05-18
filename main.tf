# main.tf
# Create VPC module if vpc_create flag is true
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  # Conditionally create the VPC module based on the vpc_create flag
  count  = var.vpc_create ? 1 : 0

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Create security group for public instances
resource "aws_security_group" "public_sg" {
  count = var.vpc_create ? 1 : 0

  name        = "public-sg"
  description = "Security group for public instances"
  vpc_id      = module.vpc[0].vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for private instances
resource "aws_security_group" "private_sg" {
  count = var.vpc_create ? 1 : 0

  name        = "private-sg"
  description = "Security group for private instances"
  vpc_id      = module.vpc[0].vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create network ACLs
resource "aws_network_acl" "public_nacl" {
  count = var.vpc_create ? 1 : 0

  vpc_id = module.vpc[0].vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    rule_action = "allow"
    cidr_block  = "0
