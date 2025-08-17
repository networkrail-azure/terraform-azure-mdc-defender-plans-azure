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

# Deterministic map for for_each instead of a set
locals {
  enabled_plans_map = { for p in sort(tolist(local.enabled_plans)) : p => p }
}

data "azurerm_subscription" "current" {}

resource "azurerm_security_center_subscription_pricing" "asc_plans" {
  for_each = local.enabled_plans_map

  tier          = var.default_tier
  resource_type = each.value
  subplan       = lookup(var.subplans, each.key, each.key == "StorageAccounts" ? "DefenderForStorageV2" : var.default_subplan)

  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["AgentlessVmScanning"], each.key), false) ? [1] : []

    content {
      name = "AgentlessVmScanning"
      additional_extension_properties = {
        ExclusionTags = "[]"
      }
    }
  }
  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["ContainerRegistriesVulnerabilityAssessments"], each.key), false) ? [1] : []

    content {
      name = "ContainerRegistriesVulnerabilityAssessments"
    }
  }
  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["AgentlessDiscoveryForKubernetes"], each.key), false) ? [1] : []

    content {
      name = "AgentlessDiscoveryForKubernetes"
    }
  }
  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["ContainerSensor"], each.key), false) ? [1] : []

    content {
      name = "ContainerSensor"
    }
  }
  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["OnUploadMalwareScanning"], each.key), false) ? [1] : []

    content {
      name = "OnUploadMalwareScanning"
      additional_extension_properties = {
        CapGBPerMonthPerStorageAccount = var.storage_accounts_malware_scan_cap_gb_per_month
      }
    }
  }
  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["SensitiveDataDiscovery"], each.key), false) ? [1] : []

    content {
      name = "SensitiveDataDiscovery"
    }
  }
  dynamic "extension" {
    for_each = try(contains(local.plan_extenstions["EntraPermissionsManagement"], each.key), false) ? [1] : []

    content {
      name = "EntraPermissionsManagement"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Merge whichever resource map exists into a single map for module-wide referencing
locals {
  asc_plans = { for k, v in azurerm_security_center_subscription_pricing.asc_plans : k => v }
}
