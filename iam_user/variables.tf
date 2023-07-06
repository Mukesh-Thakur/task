variable "user_name" {
  description = "The IAM user name"
  type        = string
  default     = "developer_access"
}

variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
  default     = "developer_policy"
}

variable "trust_policy" {
  description = "The trust policy for IAM user"
  type        = string
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::123456789012:oidc-provider/ldap-provider.example.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "ldap-provider.example.com:groups": "developer"
        }
      }
    }
  ]
}
EOF
}
