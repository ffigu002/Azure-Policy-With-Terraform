# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
terraform {
  required_version = ">= 1.0.11"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.4.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.8.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.21"
    }

  }
}

provider "azurerm" {
  environment     = var.environment
  features {}
}

#######################################################################################################
#Custom IL4 Policy
#######################################################################################################

data "azurerm_management_group" "management_group" {
  name = var.management_group_name 
}

resource "azurerm_management_group_policy_assignment" "BuiltIn_dod_il4_assignment" {
  name                 = "${var.deploy_environment}-${var.policy_set_assignment_name}"
  display_name         = "${var.deploy_environment}-${var.policy_set_assignment_name}"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/8d792a84-723c-4d92-a3c3-e4ed16a2d133"
  management_group_id  = data.azurerm_management_group.management_group.id
  identity {
    type = "SystemAssigned"
  }
  location = "USGov Virginia" #USNat or USSec dependant on the environment.
}