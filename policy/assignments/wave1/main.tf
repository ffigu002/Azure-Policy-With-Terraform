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

provider "azurerm" {
  alias       = "tier0"
  environment = var.environment
  #metadata_host   = var.metadata_host
  subscription_id = var.tier0_subid
  skip_provider_registration = true

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_management_group" "management_group" {
  name = var.management_group_name
}

data "azurerm_policy_set_definition" "Wave-1-Policy" {
  display_name = "${var.policy_set_name}-${var.management_group_name}"
  management_group_name = var.management_group_name
}

data "azurerm_resource_group" "identity_rg" {
  provider = azurerm.tier0
  name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "policy_user_managed_identity" {
  provider = azurerm.tier0
  location            = data.azurerm_resource_group.identity_rg.location
  name                = var.policy_umi_name
  resource_group_name = data.azurerm_resource_group.identity_rg.name
}

resource "azurerm_role_assignment" "policy_mi_managment_group_role_assignment_contributor" {
  provider = azurerm.tier0
  scope                = data.azurerm_management_group.management_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.policy_user_managed_identity.principal_id
}

resource "azurerm_role_assignment" "policy_mi_managment_group_role_assignment_SA" {
  provider = azurerm.tier0
  scope                = data.azurerm_management_group.management_group.id
  role_definition_name = "Security Admin"
  principal_id         = azurerm_user_assigned_identity.policy_user_managed_identity.principal_id
}

resource "azurerm_role_assignment" "policy_mi_managment_group_role_assignment_UAA" {
  provider = azurerm.tier0
  scope                = data.azurerm_management_group.management_group.id
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.policy_user_managed_identity.principal_id
}

resource "azurerm_management_group_policy_assignment" "LZ_security_wave_1_policy_set_definition_assignment" {
  name                 = "${var.policy_set_name}_assignment"
  display_name         = "${var.policy_set_name}_assignment"
  policy_definition_id = data.azurerm_policy_set_definition.Wave-1-Policy.id
  management_group_id  = data.azurerm_management_group.management_group.id
  parameters = jsonencode({
    "identity_to_virtual_machines-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = true
    },
    "byo_user_assigned_identity_to_subscription-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = true
    },
    "user_assigned_managed_identity_resource_id-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = azurerm_user_assigned_identity.policy_user_managed_identity.id
    },
    "user_assigned_managed_identity_name-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = azurerm_user_assigned_identity.policy_user_managed_identity.name
    },
    "user_assigned_managed_identity_resource_group_name-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = azurerm_user_assigned_identity.policy_user_managed_identity.resource_group_name
    },
    "built_in_identity_rg_location-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = "USGov Virginia"
    },
    "policy_effect-d367bd60-64ca-4364-98ea-276775bddd94" = {
      value = "DeployIfNotExists"
    },
    "assessment_mode-59efceea-0c96-497e-a4a1-4eb2290dac15" = {
      value = "AutomaticByPlatform"
    },
    "os_type-59efceea-0c96-497e-a4a1-4eb2290dac15" = {
      value = "Windows"
    },
    "machines_locations-59efceea-0c96-497e-a4a1-4eb2290dac15" = {
      value = ["USGov Virginia"]
    },
    "vm_tags-59efceea-0c96-497e-a4a1-4eb2290dac15" = {
      value = {}
    },
    "tag_operator-59efceea-0c96-497e-a4a1-4eb2290dac15" = {
      value = "Any"
    },
    "diagnostic_setting_name-951af2fa-529b-416e-ab6e-066fd85ac459" = {
      value = "AzureKeyVaultDiagnosticsLogsToWorkspace"
    },
    "central_log_analytics_workspace_id" = {
      value = "a932c2e9-a8f6-40c3-baf1-d6039be2434b"
    },
    "audit_event_enabled-951af2fa-529b-416e-ab6e-066fd85ac459" = {
      value = "True"
    },
    "all_metrics_enabled-951af2fa-529b-416e-ab6e-066fd85ac459" = {
      value = "True"
    },
    "enable_metrics-59759c62-9a22-4cdf-ae64-074495983fef" = {
      value = true
    },
    "effect-f81e3117-0093-4b17-8a60-82363134f0eb" = {
      value = "Modify"
    },
    "effect-e494853f-93c3-4e44-9210-d12f61a64b34" = {
      value = "DeployIfNotExists"
    },
    "effect-7cb1b219-61c6-47e0-b80c-4472cadeeb5f" = {
      value = "DeployIfNotExists"
    },
    "effect-fc4d8e41-e223-45ea-9bf5-eada37891d87" = {
      value = "Deny",
    },
    "effect-951af2fa-529b-416e-ab6e-066fd85ac459" = {
      value = "DeployIfNotExists"
    },
    "effect-405c5871-3e91-4644-8a63-58e19d68ff5b" = {
      value = "Deny"
    },
    "effect-ac673a9a-f77d-4846-b2d8-a57f8e1c01dc" = {
      value = "Modify"
    },
    "effect-59759c62-9a22-4cdf-ae64-074495983fef" = {
      value = "DeployIfNotExists"
    },
    "diagnostic_setting_name-59759c62-9a22-4cdf-ae64-074495983fef" = {
      value = "storageAccountsDiagnosticsLogstoWorkspace"
    },
    "effect-37e0d2fe-28a5-43d6-a273-67d37d1f5606" = {
      value = "Deny"
    },
    "effect-b99b73e7-074b-4089-9395-b7236f094491" = {
      value = "DeployIfNotExists" 
    },
    "effect-a06d0189-92e8-4dba-b0c4-08d7669fce7d" = {
      value = "Modify"
    }
  })
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.policy_user_managed_identity.id]
  }
  location = "USGov Virginia" #USNat or USSec dependant on the environment.
}