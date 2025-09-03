# Container-specific extensions and policy assignments
# Container policies and roles are defined in locals.tf

# Containers policy definitions (created only when enabled)
data "azurerm_policy_definition" "container_policies" {
  for_each = contains(var.mdc_plans_list, "Containers") && var.create_policy_assignments && var.enableAscForContainers == "DeployIfNotExists" ? local.container_policies : {}

  display_name = each.value.definition_display_name
}

resource "azurerm_subscription_policy_assignment" "container" {
  for_each = contains(var.mdc_plans_list, "Containers") && var.create_policy_assignments && var.enableAscForContainers == "DeployIfNotExists" ? local.container_policies : {}

  name                 = each.key
  policy_definition_id = data.azurerm_policy_definition.container_policies[each.key].id
  subscription_id      = data.azurerm_subscription.current.id
  display_name         = each.value.definition_display_name
  location             = var.location

  identity { type = "SystemAssigned" }

  depends_on = [
    azapi_update_resource.asc_plans["Containers"]
  ]
}

data "azurerm_role_definition" "container_roles" {
  for_each = contains(var.mdc_plans_list, "Containers") && var.create_policy_assignments && var.enableAscForContainers == "DeployIfNotExists" ? local.container_roles : {}

  name  = each.value.name
  scope = data.azurerm_subscription.current.id
}

resource "azurerm_role_assignment" "va_auto_provisioning_containers_role" {
  for_each = contains(var.mdc_plans_list, "Containers") && var.create_policy_assignments && var.enableAscForContainers == "DeployIfNotExists" ? local.container_roles : {}

  principal_id       = azurerm_subscription_policy_assignment.container[each.value.policy].identity[0].principal_id
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.container_roles[each.key].id
}