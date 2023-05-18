# variables.tf

# Configure provider (AWS in this example)
provider "aws" {
  region = "us-east-1"
} 

variable "stage" {
  type    = string
  default = "dev"
}

# Define variables
variable "vpc_create" {
  type    = bool
  default = false
}

variable "vpc_name" {
  type    = string
  default = "my-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

