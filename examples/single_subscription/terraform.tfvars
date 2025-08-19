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

enable_telemetry          = false
create_policy_assignments = true



subscription_id = "0e02fdda-075c-4944-b128-d918a1219489"

# Optional: provide an existing Data Collection Rule (DCR) resource id to associate.
# When set, the module will create an azurerm_monitor_data_collection_rule_association
# to attach the DCR to the `dcr_association_scope_id` (derived from subscription_id
# or the current authenticated subscription).
# Example format:
# "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Insights/dataCollectionRules/<dcr-name>"
existing_dcr_id = ""