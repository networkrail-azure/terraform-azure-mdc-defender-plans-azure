# Container policies/roles map drives consistent keys across data lookups, policy assignments, and role bindings
locals {
  container_policies = {
    mdc-containers-kubernetes1-autoprovisioning-containers = {
      definition_display_name = "Configure Azure Arc enabled Kubernetes clusters to install the Azure Policy extension"
    }
    mdc-cmdc-containers-kubernetes2-autoprovisioning-containers = {
      definition_display_name = "Deploy Azure Policy Add-on to Azure Kubernetes Service clusters"
    }
    mdc-containers_aks_autoprovisioning-containers = {
      definition_display_name = "Configure Azure Kubernetes Service clusters to enable Defender profile"
    }
    mdc-containers-arc-autoprovisioning-containers = {
      definition_display_name = "[Preview]: Configure Azure Arc enabled Kubernetes clusters to install Microsoft Defender for Cloud extension"
    }
  }
  container_roles = {
    containers-kubernetes1-role-1 = {
      name   = "Kubernetes Extension Contributor"
      policy = "mdc-containers-kubernetes1-autoprovisioning-containers"
    }
    containers-kubernetes2-role-1 = {
      name   = "Azure Kubernetes Service Contributor Role"
      policy = "mdc-cmdc-containers-kubernetes2-autoprovisioning-containers"
    }
    containers-kubernetes2-role-2 = {
      name   = "Azure Kubernetes Service Policy Add-on Deployment"
      policy = "mdc-cmdc-containers-kubernetes2-autoprovisioning-containers"
    }
    # The following are Azure built-in role display names used for RBAC bindings.
    containers-aks-role-1 = {
      name   = "Log Analytics Contributor"
      policy = "mdc-containers_aks_autoprovisioning-containers"
    }
    containers-aks-role-2 = {
      name   = "Contributor"
      policy = "mdc-containers_aks_autoprovisioning-containers"
    }
    containers-arc-role-1 = {
      name   = "Log Analytics Contributor"
      policy = "mdc-containers-arc-autoprovisioning-containers"
    }
    containers-arc-role-2 = {
      name   = "Contributor"
      policy = "mdc-containers-arc-autoprovisioning-containers"
    }
  }
}

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
    azapi_resource.asc_plans["Containers"]
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