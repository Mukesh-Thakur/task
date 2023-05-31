
provider "aws" {
  region = "ap-south-1"
}

variable "create_ec2_instance" {
  description = "Flag to create EC2 instance module"
  type        = bool
  default     = true
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "ec2-count" {
  description = "Total Number of instances needs to be created"
  type        = number
  default     = 4
}

variable "eip-count" {
  description = "Total Number of instances needs to be created"
  type        = number
  default     = 2
}

variable "ec2_instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "my-ec2-instance"
}

variable "ec2_instance_ami" {
  description = "AMI ID of the EC2 instance"
  type        = string
  default     = "ami-02eb7a4783e7e9317"
}

variable "ec2_instance_type" {
  description = "Instance type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "ec2_instance_tags" {
  description = "Additional tags for the EC2 instance"
  type        = map(string)
  default     = {}
}

variable "ec2_sg" {
  description = "Instance type of the EC2 instance"
  type        = string
  default     = "sg-12345678"
}

variable "public_subnet_ids" {
  description = "Instance type of the EC2 instance"
  type        = string
  default     = "subnet-1235678"
}

variable "create_asg" {
  description = "Flag to create Autoscaling Group"
  type        = bool
  default     = true
}

variable "asg_name" {
  description = "Name of the Autoscaling Group"
  type        = string
  default     = "my-asg"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Autoscaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Autoscaling Group"
  type        = number
  default     = 5
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Autoscaling Group"
  type        = number
  default     = 2
}

variable "create_ebs_volume" {
  description = "Flag to create EBS volume"
  type        = bool
  default     = false
}

variable "launch_template_name" {
  description = "Name of the Launch template"
  type        = string
  default     = "example-lt"
}

variable "ebs_volume_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 10
}

variable "ebs_volume_type" {
  description = "Type of the EBS volume"
  type        = string
  default     = "gp2"
}

variable "create_elastic_ip" {
  description = "Flag to create Elastic IP"
  type        = bool
  default     = false
}
