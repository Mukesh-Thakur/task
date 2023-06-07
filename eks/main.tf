module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  self_managed_node_group_defaults = var.self_managed_node_group_defaults

  self_managed_node_groups = var.self_managed_node_groups

  eks_managed_node_group_defaults = var.eks_managed_node_group_defaults

  eks_managed_node_groups = var.eks_managed_node_groups

  fargate_profiles = var.fargate_profiles

  manage_aws_auth_configmap = var.manage_aws_auth_configmap

  aws_auth_roles    = var.aws_auth_roles
  aws_auth_users    = var.aws_auth_users
  aws_auth_accounts = var.aws_auth_accounts

  tags = var.tags
}
