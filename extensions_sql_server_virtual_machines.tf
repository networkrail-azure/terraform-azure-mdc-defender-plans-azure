locals {
  sql_server_virtual_machines_enabled = contains(local.plans_without_databases, "SqlServerVirtualMachines") && !contains(var.mdc_plans_list, "VirtualMachines")
}