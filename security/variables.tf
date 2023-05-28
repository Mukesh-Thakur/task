#Provider
provider "aws" {
  region = "us-west-1"
}

#ACM Variables
variable "domain_name" {
  description = "The domain name for ACM"
  type        = string
  default     = "example.com"
}

variable "zone_id" {
  description = "The Route 53 zone ID"
  type        = string
  default     = "us-east-1a"
}

variable "subject_alternative_names" {
  description = "List of subject alternative names"
  type        = list(string)
  default     = ["www.example.com"]
}

# KMS variable 
variable "key_description" {
  description = "Description for the KMS key"
  type        = string
  default     = "EC2 AutoScaling key usage"
}

variable "key_usage" {
  description = "Key usage for the KMS key"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "key_administrators" {
  description = "List of key administrators"
  type        = list(string)
  default     = []
}

variable "key_service_roles_for_autoscaling" {
  description = "List of key service roles for autoscaling"
  type        = list(string)
  default     = []
}

variable "key_aliases" {
  description = "List of key aliases"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for the KMS key"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# IAM variables

variable "source_bucket_name" {
  description = "Name of the source S3 bucket"
  type        = string
  default     = "source-bucket"
}

variable "destination_bucket_name" {
  description = "Name of the destination S3 bucket"
  type        = string
  default     = "destination-bucket"
}

variable "source_bucket_prefix" {
  description = "Prefix for objects in the source S3 bucket"
  type        = string
  default     = "images"
}
