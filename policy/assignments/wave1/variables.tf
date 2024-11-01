############################### Data Source variables################################################
variable "management_group_name" {
  type        = any
  description = "Management group for deployment"
}

variable "tier0_subid" {
  description = "Subscription ID for the deployment"
  type        = string
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "policy_set_name" {
  type        = string
  description = "The name of the policy set and assignment."
}

################################ User Managed Identity Variables ##################################

variable "policy_umi_name" {
  type = string
  description = "the user managed identity name"
}

###################################################################################################
#Policy Variables
##################################################################################################

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}