
##################################################################################\
#Policy Variables
##################################################################################

variable "management_group_name" {
  type        = any
  description = "Management group for deployment"
}

variable "policy_set_name" {
  type        = string
  description = "The name of the policy set and assignment."
  default     = "IL4-Initiative"
}

variable "policy_type" {
  type        = string
  description = "The type of the policy deployment."
  default     = "BuiltIn"
}

variable "policy_mode" {
  type        = string
  description = "The mode of the policy deployment."
  default     = "All"
}

variable "policy_description" {
  type        = string
  description = "The description to provide for the policy assignment."
  default     = "This initiative includes policies that address a subset of DoD Impact Level 4 (IL4) controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/dodil4-initiative."
}

variable "policy_set_assignment_name" {
  type        = string
  description = "The name of the policy set and assignment."
  default     = "IL4-Assignment"
}

variable "deploy_environment" {
  description = "The environment (dev or prod)"
  type        = string
  default     = "Mgmt"
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}