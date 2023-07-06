variable "users" {
  type = map(list(string))
  default = {
    developers       = ["developer_policy"]
    testers          = ["tester_policy"]
    admins           = ["admin_policy"]
    devops_engineers = ["devops_policy"]
  }
}

variable "trust_policies" {
  type = map(string)
  default = {
    developers       = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
    testers          = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
    admins           = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
    devops_engineers = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
  }
}

resource "aws_iam_user" "users" {
  for_each = var.users

  name = each.key
}

resource "aws_iam_user_policy_attachment" "user_policy_attachments" {
  for_each = var.users

  user       = aws_iam_user.users[each.key].name
  policy_arn = aws_iam_policy.policy[each.key].arn
}

resource "aws_iam_policy" "policy" {
  for_each = var.users

  name        = each.value[0]
  description = "Policy for ${each.key}"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAll"
        Effect    = "Allow"
        Action    = "*"
        Resource  = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ldap_roles" {
  for_each = var.trust_policies

  name               = "${each.key}_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Federated = each.value
        }
        Action    = "sts:AssumeRoleWithWebIdentity"
      }
    ]
  })
}
