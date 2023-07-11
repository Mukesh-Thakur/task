# outputs.tf

output "iam_user_names" {
  description = "List of IAM user names"
  value       = [for user in aws_iam_user.iam_users : user.name]
}

output "iam_role_names" {
  description = "List of IAM role names"
  value       = [for role in aws_iam_role.iam_user_roles : role.name]
}
