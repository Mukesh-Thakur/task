# main.tf

# Create IAM users and attach policies using for_each loop
resource "aws_iam_user" "iam_users" {
  for_each = var.users

  name = each.key
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attachments" {
  for_each = var.users

  user       = aws_iam_user.iam_users[each.key].name
  policy_arn = aws_iam_policy.iam_policies[each.key].arn
}

# Create IAM policies using for_each loop
resource "aws_iam_policy" "iam_policies" {
  for_each = var.users

  name        = each.key
  path        = "/"
  description = each.key
  policy      = file(each.value.policy_file)
}

# Create IAM role with trust policies for each user
resource "aws_iam_role" "iam_user_roles" {
  for_each = var.users

  name               = "${each.key}_role"
  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [
      {
        "Sid"      : "",
        "Effect"   : "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::123456789012:oidc-provider/your-ldap-provider-url"
        },
        "Action"   : "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "aws:userid": join("", [aws_iam_user.iam_users[each.key].name])
          }
        }
      }
    ]
  })
}
