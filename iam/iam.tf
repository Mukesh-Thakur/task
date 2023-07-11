module "iam" {
  source = "../iam-module"

  users = {
    developers = {
      policy_file   = "developers_policy.json"
      trust_policies = ["LDAPGroup1"]
    }
    admins = {
      policy_file   = "admins_policy.json"
      trust_policies = ["LDAPGroup2"]
    }
    testers = {
      policy_file   = "testers_policy.json"
      trust_policies = ["LDAPGroup3"]
    }
    "devops_engineer" = {
      policy_file   = "devops_engineers_policy.json"
      trust_policies = ["LDAPGroup4"]
    }
  }
}
