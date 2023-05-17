# main.tf

variable "stage" {
  type    = string
  default = "dev"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name                 = "${var.stage}-vpc"
  cidr                 = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Other VPC configuration parameters...
}

