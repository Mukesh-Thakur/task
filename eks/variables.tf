variable "cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "cluster_version" {
  type    = string
  default = "1.27"
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type    = string
  default = "vpc-1234556abcdef"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
}

variable "control_plane_subnet_ids" {
  type    = list(string)
  default = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]
}

variable "self_managed_node_group_defaults" {
  type = object({
    instance_type                          = string
    update_launch_template_default_version = bool
    iam_role_additional_policies           = map(string)
  })
  default = {
    instance_type                          = "m6i.large"
    update_launch_template_default_version = true
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }
}

variable "self_managed_node_groups" {
  type = map(object({
    name                       = string
    max_size                   = number
    desired_size               = number
    use_mixed_instances_policy = bool
    mixed_instances_policy = object({
      instances_distribution = object({
        on_demand_base_capacity                  = number
        on_demand_percentage_above_base_capacity = number
        spot_allocation_strategy                 = string
      })
      override = list(object({
        instance_type     = string
        weighted_capacity = string
      }))
    })
  }))
  default = {
    one = {
      name         = "mixed-1"
      max_size     = 5
      desired_size = 2

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy                 = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          },
          {
            instance_type     = "m6i.large"
            weighted_capacity = "2"
          },
        ]
      }
    }
  }
}

variable "eks_managed_node_group_defaults" {
  type = object({
    instance_types = list(string)
  })
  default = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }
}

variable "eks_managed_node_groups" {
  type = map(object({
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_types = list(string)
    capacity_type  = string
  }))
  default = {
    blue = {
      min_size       = 0
      max_size       = 0
      desired_size   = 0
      instance_types = []
      capacity_type  = ""
    }
    green = {
      min_size       = 1
      max_size       = 10
      desired_size   = 1
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }
}

variable "fargate_profiles" {
  type = map(object({
    name = string
    selectors = list(object({
      namespace = string
    }))
  }))
  default = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }
}

variable "manage_aws_auth_configmap" {
  type    = bool
  default = true
}

variable "aws_auth_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "aws_auth_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}

variable "aws_auth_accounts" {
  type    = list(string)
  default = ["777777777777", "888888888888"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
  }
}
