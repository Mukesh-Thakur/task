provider "aws" {
  region = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "ecs-integrated"
}

variable "cluster_logging" {
  description = "Cluster logging configuration"
  type        = string
  default     = "OVERRIDE"
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "/aws/ecs/aws-ec2"
}

variable "fargate_capacity_providers" {
  description = "Map of Fargate capacity providers and their weights"
  type = map(object({
    default_capacity_provider_strategy = object({
      weight = number
    })
  }))
  default = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}

variable "frontend_cpu" {
  description = "CPU units for the ecsdemo-frontend service"
  type        = number
  default     = 1024
}

variable "frontend_memory" {
  description = "Memory limit (in MiB) for the ecsdemo-frontend service"
  type        = number
  default     = 4096
}

variable "fluent_bit_cpu" {
  description = "CPU units for the fluent-bit container"
  type        = number
  default     = 512
}

variable "fluent_bit_memory" {
  description = "Memory limit (in MiB) for the fluent-bit container"
  type        = number
  default     = 1024
}

variable "fluent_bit_image" {
  description = "Docker image for the fluent-bit container"
  type        = string
  default     = "906394416424.dkr.ecr.us-west-2.amazonaws.com/aws-for-fluent-bit:stable"
}

variable "fluent_bit_memory_reservation" {
  description = "Memory reservation (in MiB) for the fluent-bit container"
  type        = number
  default     = 50
}

variable "ecs_sample_cpu" {
  description = "CPU units for the ecs-sample container"
  type        = number
  default     = 512
}

variable "ecs_sample_memory" {
  description = "Memory limit (in MiB) for the ecs-sample container"
  type        = number
  default     = 1024
}

variable "ecs_sample_image" {
  description = "Docker image for the ecs-sample container"
  type        = string
  default     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
}

variable "ecs_sample_container_port" {
  description = "Container port for the ecs-sample container"
  type        = number
  default     = 80
}

variable "ecs_sample_readonly_root_filesystem" {
  description = "Whether to enable readonly root filesystem for the ecs-sample container"
  type        = bool
  default     = false
}

variable "ecs_sample_enable_cloudwatch_logging" {
  description = "Whether to enable CloudWatch logging for the ecs-sample container"
  type        = bool
  default     = false
}

variable "ecs_sample_log_driver" {
  description = "Log driver for the ecs-sample container"
  type        = string
  default     = "awsfirelens"
}

variable "ecs_sample_log_driver_name" {
  description = "Name of the log driver for the ecs-sample container"
  type        = string
  default     = "firehose"
}

variable "ecs_sample_log_driver_region" {
  description = "AWS region for the log driver of the ecs-sample container"
  type        = string
  default     = "eu-west-1"
}

variable "ecs_sample_log_driver_delivery_stream" {
  description = "Name of the delivery stream for the log driver of the ecs-sample container"
  type        = string
  default     = "my-stream"
}

variable "ecs_sample_log_driver_buffer_limit" {
  description = "Buffer limit for the log driver of the ecs-sample container"
  type        = string
  default     = "2097152"
}

variable "ecs_sample_memory_reservation" {
  description = "Memory reservation (in MiB) for the ecs-sample container"
  type        = number
  default     = 100
}

variable "service_connect_namespace" {
  description = "Namespace for service discovery in service connect configuration"
  type        = string
  default     = "example"
}

variable "service_connect_port" {
  description = "Port for service discovery in service connect configuration"
  type        = number
  default     = 80
}

variable "service_connect_dns_name" {
  description = "DNS name for service discovery in service connect configuration"
  type        = string
  default     = "ecs-sample"
}

variable "service_connect_port_name" {
  description = "Port name for service discovery in service connect configuration"
  type        = string
  default     = "ecs-sample"
}

variable "service_connect_discovery_name" {
  description = "Discovery name for service discovery in service connect configuration"
  type        = string
  default     = "ecs-sample"
}

variable "subnet_ids" {
  description = "List of subnet IDs where the ECS service will be deployed"
  type        = list(string)
  default     = ["subnet-0b95719f5c8f3d6ad"]
}

variable "tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Example"
  }
}

variable "security_group_rules" {
  description = "Security group rules for the ECS service"
  type = map(object({
    type                     = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = optional(string)
    source_security_group_id = optional(string)
    cidr_blocks              = optional(list(string))
  }))
  default = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = "sg-12345678"
      cidr_blocks              = null # Set it to null or provide a valid CIDR block if required
    }
    egress_all = {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      description              = "Egress all traffic"
      source_security_group_id = null # Set it to null or provide a valid source security group ID if required
      cidr_blocks              = ["0.0.0.0/0"]
    }
  }
}
