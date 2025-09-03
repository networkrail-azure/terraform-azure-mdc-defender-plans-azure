locals {
  plan_extenstions = {
    AgentlessVmScanning                         = tolist(["VirtualMachines", "CloudPosture", "Containers"])
    ContainerRegistriesVulnerabilityAssessments = tolist(["Containers", "CloudPosture"])
    AgentlessDiscoveryForKubernetes             = tolist(["Containers", "CloudPosture"])
    ContainerSensor                             = tolist(["Containers"])
    OnUploadMalwareScanning                     = tolist(["StorageAccounts"])
    SensitiveDataDiscovery                      = tolist(["CloudPosture", "StorageAccounts"])
    EntraPermissionsManagement                  = tolist(["CloudPosture"])
  }
  plans_without_databases = contains(var.mdc_plans_list, "Databases") ? setsubtract(setunion(var.mdc_plans_list, var.mdc_databases_plans), ["Databases"]) : var.mdc_plans_list
}
locals {
  enabled_plans_map = { for p in sort(tolist(local.enabled_plans)) : p => p }
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

# Calculate extensions for each plan
locals {
  # Build extensions list for each plan
  plan_extensions = {
    for plan in keys(local.enabled_plans_map) : plan => concat(
      # AgentlessVmScanning
      contains(lookup(local.plan_extenstions, "AgentlessVmScanning", []), plan) ? [{
        name = "AgentlessVmScanning"
        isEnabled = "True"
        additionalExtensionProperties = {
          ExclusionTags = "[]"
        }
      }] : [],
      # ContainerRegistriesVulnerabilityAssessments
      contains(lookup(local.plan_extenstions, "ContainerRegistriesVulnerabilityAssessments", []), plan) ? [{
        name = "ContainerRegistriesVulnerabilityAssessments"
        isEnabled = "True"
      }] : [],
      # AgentlessDiscoveryForKubernetes
      contains(lookup(local.plan_extenstions, "AgentlessDiscoveryForKubernetes", []), plan) ? [{
        name = "AgentlessDiscoveryForKubernetes"
        isEnabled = "True"
      }] : [],
      # ContainerSensor
      contains(lookup(local.plan_extenstions, "ContainerSensor", []), plan) ? [{
        name = "ContainerSensor"
        isEnabled = "True"
      }] : [],
      # OnUploadMalwareScanning
      contains(lookup(local.plan_extenstions, "OnUploadMalwareScanning", []), plan) ? [{
        name = "OnUploadMalwareScanning"
        isEnabled = "True"
        additionalExtensionProperties = {
          CapGBPerMonthPerStorageAccount = var.storage_accounts_malware_scan_cap_gb_per_month
        }
      }] : [],
      # SensitiveDataDiscovery
      contains(lookup(local.plan_extenstions, "SensitiveDataDiscovery", []), plan) ? [{
        name = "SensitiveDataDiscovery"
        isEnabled = "True"
      }] : [],
      # EntraPermissionsManagement
      contains(lookup(local.plan_extenstions, "EntraPermissionsManagement", []), plan) ? [{
        name = "EntraPermissionsManagement"
        isEnabled = "True"
      }] : []
    )
  }
}

resource "azapi_update_resource" "asc_plans" {
  for_each = local.enabled_plans_map

  type        = "Microsoft.Security/pricings@2024-01-01"
  resource_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Security/pricings/${each.value}"

  body = {
    properties = {
      pricingTier = var.default_tier
      subPlan     = lookup(var.subplans, each.key, each.key == "StorageAccounts" ? "DefenderForStorageV2" : var.default_subplan)
      extensions  = local.plan_extensions[each.key]
    }
  }
}

# Merge whichever resource map exists into a single map for module-wide referencing
locals {
  asc_plans = { for k, v in azapi_update_resource.asc_plans : k => v }
}
