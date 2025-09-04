ascExportResourceGroupLocation = "uksouth"
ascExportResourceGroupName     = "rg-mdc-export"
createResourceGroup            = true

emailSecurityContact = "secops@example.com"
minimalSeverity      = "High"

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

enable_telemetry          = true
create_policy_assignments = true

subscription_id = "aeae01d6-b328-4a0f-a317-d98e4af21290"