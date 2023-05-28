module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description                       = var.key_description
  key_usage                         = var.key_usage
  key_administrators                = var.key_administrators
  key_service_roles_for_autoscaling = var.key_service_roles_for_autoscaling
  aliases                           = var.key_aliases
  tags                              = var.tags
}
