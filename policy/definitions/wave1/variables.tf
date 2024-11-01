
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
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}