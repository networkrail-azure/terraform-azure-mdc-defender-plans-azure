# Enabling vm extensions - Vulnerability assessment
data "azurerm_policy_definition" "vm_policies" {
  for_each = contains(var.mdc_plans_list, "VirtualMachines") && var.create_policy_assignments && var.enableAscForServersVulnerabilityAssessments == "DeployIfNotExists" ? local.virtual_machine_policies : {}

  display_name = each.value.definition_display_name
}

resource "azurerm_subscription_policy_assignment" "vm" {
  for_each = contains(var.mdc_plans_list, "VirtualMachines") && var.create_policy_assignments && var.enableAscForServersVulnerabilityAssessments == "DeployIfNotExists" ? local.virtual_machine_policies : {}

  name                 = each.key
  policy_definition_id = data.azurerm_policy_definition.vm_policies[each.key].id
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = each.value.definition_display_name
  location             = var.location
  parameters           = each.key == "mdc-va-autoprovisioning-vm" ? local.va_type : null

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azapi_update_resource.asc_plans["VirtualMachines"]
  ]
}

# Enabling vm extensions - Endpoint protection
resource "azapi_update_resource" "setting_mcas" {
  count = contains(var.mdc_plans_list, "VirtualMachines") && var.enableTvmCheck == "DeployIfNotExists" ? 1 : 0

  type        = "Microsoft.Security/settings@2022-05-01"
  resource_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Security/settings/WDATP"

  body = {
    properties = {
      enabled = true
    }
  }

  depends_on = [
    azapi_update_resource.asc_plans["VirtualMachines"]
  ]
}

# Enabling vm Roles
data "azurerm_role_definition" "vm_roles" {
  for_each = contains(var.mdc_plans_list, "VirtualMachines") && var.create_policy_assignments && var.enableAscForServersVulnerabilityAssessments == "DeployIfNotExists" ? local.virtual_machine_roles : {}

  name  = each.value.name
  scope = data.azurerm_subscription.current.id
}

resource "azurerm_role_assignment" "va_auto_provisioning_vm_role" {
  for_each = contains(var.mdc_plans_list, "VirtualMachines") && var.create_policy_assignments && var.enableAscForServersVulnerabilityAssessments == "DeployIfNotExists" ? local.virtual_machine_roles : {}

  principal_id       = azurerm_subscription_policy_assignment.vm[each.value.policy].identity[0].principal_id
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.vm_roles[each.key].id
}