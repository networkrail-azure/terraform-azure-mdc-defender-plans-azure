variable "enable_telemetry" {
  type    = bool
  default = false
}

variable "mdc_plans_list" {
  type = set(string)
  default = [
    "AppServices",
    "Arm",
    "CloudPosture",
    "Containers",
    "KeyVaults",
    "OpenSourceRelationalDatabases",
    "SqlServers",
    "SqlServerVirtualMachines",
    "CosmosDbs",
    "StorageAccounts",
    "VirtualMachines",
  ]
  description = "(Optional) Set of all MDC plans"
}

variable "subplans" {
  type = map(string)
  default = {
    VirtualMachines = "P2"
    Arm             = "PerSubscription"
    KeyVaults       = "PerKeyVault"
  }
  description = "(Optional) A map of resource type pricing subplan, the key is resource type. This variable takes precedence over `var.default_subplan`."
}

variable "create_policy_assignments" {
  type    = bool
  default = true
}



# Export / integration options used in example
variable "logAnalytics" {
  type    = string
  default = ""
}

variable "ascExportResourceGroupLocation" {
  type    = string
  default = "westeurope"
}

variable "ascExportResourceGroupName" {
  type    = string
  default = "rg-mdc-export"
}

variable "createResourceGroup" {
  type    = bool
  default = true
}

# Notifications / contacts
variable "emailSecurityContact" {
  type    = string
  default = ""
}

variable "minimalSeverity" {
  type    = string
  default = "High"
}

# Per-plan toggles used by the module (strings expected, e.g. "DeployIfNotExists" or "Disabled")
variable "enableAscForServers" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForServersVulnerabilityAssessments" {
  type    = string
  default = "DeployIfNotExists"
}

variable "vulnerabilityAssessmentProvider" {
  type    = string
  default = "mdeTvm"
}

variable "enableTvmCheck" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForAppServices" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForSql" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForOssDb" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForCosmosDbs" {
  type    = string
  default = "Disabled"
}

variable "enableAscForStorage" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForContainers" {
  type    = string
  default = "Disabled"
}

variable "enableAscForArm" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForCspm" {
  type    = string
  default = "DeployIfNotExists"
}

variable "enableAscForSqlOnVm" {
  type    = string
  default = "Disabled"
}

variable "enableAscForKeyVault" {
  type    = string
  default = "DeployIfNotExists"
}

variable "subscription_id" {
  type    = string
  default = ""
  description = "(Optional) Subscription id to target for this example. If empty, provider will use the currently authenticated subscription."
}

