# main.tf

variable "stage" {
  type    = string
  default = "dev"
}

variable "vpc_flag" {
  type    = bool
  default = false
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  count   = var.vpc_flag ? 1 : 0

  name                 = "${var.stage}-vpc"
  cidr                 = "10.0.0.0/16"
# cidr                 = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Other VPC configuration parameters...
}

