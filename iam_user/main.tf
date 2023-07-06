module "aws_users" {
  source = "./module"
  
  users = {
    developers       = ["developer_policy"]
    testers          = ["tester_policy"]
    admins           = ["admin_policy"]
    devops_engineers = ["devops_policy"]
  }
  
  trust_policies = {
    developers       = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
    testers         = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
    admins           = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
    devops_engineers = "arn:aws:iam::123456789012:oidc-provider/ldap-provider"
  }
}
