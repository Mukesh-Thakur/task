# variables.tf

variable "users" {
  description = "Map of users and their policy information"
  type        = map(object({
    policy_file   = string
    trust_policies = list(string)
  }))
}
