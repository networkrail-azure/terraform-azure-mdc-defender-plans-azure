locals {
  # Deprecated plans that should be excluded
  disallowed_plans = toset(["Api"]) # deprecated by Microsoft
  
  # Database handling - expand databases into individual plans
  plans_without_databases = contains(var.mdc_plans_list, "Databases") ? setsubtract(setunion(var.mdc_plans_list, var.mdc_databases_plans), ["Databases"]) : var.mdc_plans_list
  
  # Final enabled plans after removing disallowed ones
  enabled_plans = setsubtract(local.plans_without_databases, local.disallowed_plans)
  
  # Convert to deterministic map for for_each loops
  enabled_plans_map = { for p in sort(tolist(local.enabled_plans)) : p => p }
}

locals {
  # Define which extensions apply to which plans
  plan_extenstions = {
    AgentlessVmScanning                         = tolist(["VirtualMachines", "CloudPosture", "Containers"])
    ContainerRegistriesVulnerabilityAssessments = tolist(["Containers", "CloudPosture"])
    AgentlessDiscoveryForKubernetes             = tolist(["Containers", "CloudPosture"])
    ContainerSensor                             = tolist(["Containers"])
    OnUploadMalwareScanning                     = tolist(["StorageAccounts"])
    SensitiveDataDiscovery                      = tolist(["CloudPosture", "StorageAccounts"])
    EntraPermissionsManagement                  = tolist(["CloudPosture"])
  }

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

locals {
  # Unified reference to all created pricing plans
  asc_plans = { for k, v in azapi_update_resource.asc_plans : k => v }
}

locals {
  # Container policies/roles map drives consistent keys across data lookups, policy assignments, and role bindings
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

locals {
  # Vulnerability assessment configuration
  va_type = jsonencode({
    "vaType" = {
      "value" = "mdeTvm"
    }
  })
  
  # Virtual machine policies
  virtual_machine_policies = {
    mdc-va-autoprovisioning-vm = {
      definition_display_name = "Configure machines to receive a vulnerability assessment provider"
    }
  }
  
  # Virtual machine roles
  virtual_machine_roles = {
    virtual-machines-va-role-1 = {
      name   = "Security Admin"
      policy = "mdc-va-autoprovisioning-vm"
    }
  }
}

locals {
  # Determine if SQL Server VM plans should be enabled
  sql_server_virtual_machines_enabled = contains(local.plans_without_databases, "SqlServerVirtualMachines") && !contains(var.mdc_plans_list, "VirtualMachines")
}

locals {
  # DCR creation control
  should_create_dcr = var.enable_telemetry
  
  # Auto-generate names using region
  dcr_name                = "dcr-mdc-${var.location}"
  dcr_resource_group_name = "rg-mdc-dcr-${var.location}"
}
