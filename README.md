# Azure Policy Implementation via Terraform

This repository demonstrates how to implement Azure Policy using Terraform. It includes two examples:
1. Assigning an existing policy definition named `DoD IL4 Initiative`.
2. Creating an initiative definition from a JSON file and assigning it to a management group.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed.
- Azure subscription with necessary permissions.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and logged in.

## Usage

### Example 1: Assigning an Existing Policy Definition

This example shows how to assign an existing policy definition named `DoD IL4 Initiative`. The configuration code can be found under "assignments\dod-il4-initiaive"

```hcl
provider "azurerm" {
  features {}
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


### Example 2: Example 2: Creating and Assigning an Initiative Definition

This example demonstrates how to create an initiative definition from a JSON file named "Wave 1" and assign it to a management group. The definition can be found under "definitions\wave1" and assignment under the directory "assignments\wave1"

TODO
