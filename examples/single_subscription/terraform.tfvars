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

enable_telemetry          = true  # Enable telemetry to allow DCR creation
create_policy_assignments = true

subscription_id = "aeae01d6-b328-4a0f-a317-d98e4af21290"

# Option 1: Create a DCR automatically (when create_dcr = true and enable_telemetry = true)
# The DCR will use the existing Log Analytics workspace: law-management-uksouth
create_dcr = true
dcr_name = "mdc-example-dcr"
dcr_resource_group_name = "rg-mdc-example-dcr"

# The module will create an azurerm_monitor_data_collection_rule_association
# to attach the DCR to the dcr_association_scope_id (derived from subscription_id
# or the current authenticated subscription).