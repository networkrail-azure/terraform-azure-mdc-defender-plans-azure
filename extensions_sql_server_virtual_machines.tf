locals {
  sql_server_virtual_machines_enabled = contains(local.plans_without_databases, "SqlServerVirtualMachines") && !contains(var.mdc_plans_list, "VirtualMachines")
}

// Legacy Log Analytics (MMA) policies and role assignments have been removed.
// If you need to perform any agent provisioning or data collection, use AMA/DCR
// or the `VirtualMachines` plan instead.