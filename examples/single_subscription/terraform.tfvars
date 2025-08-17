ascExportResourceGroupLocation = "uksouth"
ascExportResourceGroupName     = "rg-mdc-export"
createResourceGroup            = true

emailSecurityContact = "secops@example.com"
minimalSeverity      = "High"

# enableAscForServers                         = "DeployIfNotExists"
# enableAscForServersVulnerabilityAssessments = "DeployIfNotExists"
# vulnerabilityAssessmentProvider             = "mdeTvm"
# enableTvmCheck                              = "DeployIfNotExists"

# enableAscForAppServices = "DeployIfNotExists"

# enableAscForSql       = "DeployIfNotExists"
# enableAscForOssDb     = "DeployIfNotExists"
# enableAscForCosmosDbs = "Disabled"

# enableAscForStorage    = "DeployIfNotExists"
# enableAscForContainers = "Disabled"

# enableAscForArm  = "DeployIfNotExists"
# enableAscForCspm = "DeployIfNotExists"

# enableAscForSqlOnVm = "Disabled"

# enableAscForKeyVault = "DeployIfNotExists"

mdc_plans_list = [
  "AppServices",
  "Arm",
  "CloudPosture",
  "KeyVaults",
  "OpenSourceRelationalDatabases",
  "SqlServers",
  "SqlServerVirtualMachines",
  "CosmosDbs",
  "StorageAccounts",
  "VirtualMachines",
]

subplans = {
  VirtualMachines = "P2"
  Arm             = "PerSubscription"
  KeyVaults       = "PerKeyVault"
}

enable_telemetry          = false
create_policy_assignments = true



subscription_id = "0e02fdda-075c-4944-b128-d918a1219489"