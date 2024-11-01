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

data "azurerm_management_group" "management_group" {
  name = var.management_group_name
}

locals {
  jsondata                 = jsondecode(file("wave1-policy.json"))
  display_name             = local.jsondata.properties.displayName
  policy_type              = local.jsondata.properties.policyType
  description              = try(local.jsondata.properties.description, "")
  metadata                 = jsonencode(local.jsondata.properties.metadata)
  parameters               = jsonencode(local.jsondata.properties.parameters)
  policy_definitions       = local.jsondata.properties.policyDefinitions
  policy_definition_groups = local.jsondata.properties.policyDefinitionGroups
}

resource "azurerm_policy_set_definition" "LZ_security_wave_1_policy_set_definition" {
  name         = "${local.display_name}-${var.management_group_name}"
  policy_type  = local.policy_type
  display_name = "${local.display_name}-${var.management_group_name}"
  description  = local.description
  metadata     = local.metadata
  parameters   = local.parameters
  management_group_id = data.azurerm_management_group.management_group.id

  dynamic "policy_definition_reference" {
    for_each = local.policy_definitions

    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = try(length(policy_definition_reference.value["parameters"]) > 0, false) ? jsonencode(policy_definition_reference.value["parameters"]) : ""
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
      policy_group_names   = policy_definition_reference.value["groupNames"]
    }
  }

  dynamic "policy_definition_group" {
    for_each = local.policy_definition_groups

    content {
      name         = policy_definition_group.value["name"]
      category     = policy_definition_group.value["category"]
      display_name = policy_definition_group.value["displayName"]
      description  = policy_definition_group.value["description"]
    }
  }
}
