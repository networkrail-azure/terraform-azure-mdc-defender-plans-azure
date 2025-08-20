# Data block to reference existing Log Analytics workspace
data "azurerm_log_analytics_workspace" "management" {
  name                = "law-management-uksouth"
  resource_group_name = "rg-management-uksouth"
}

module "mdc_plans_enable" {
  source           = "../.."
  subscription_id  = var.subscription_id
  mdc_plans_list   = var.mdc_plans_list
  subplans         = var.subplans
  enable_telemetry = var.enable_telemetry

  # Opt-in AMA DCR creation and wiring
  # When create_dcr is true, the module will create a DCR using an existing workspace
  create_dcr                   = var.create_dcr
  dcr_association_scope_id     = local.example_dcr_association_scope_id
  
  # Required: provide existing workspace and customize DCR names when create_dcr is true
  dcr_name                     = var.dcr_name
  dcr_workspace_resource_id    = data.azurerm_log_analytics_workspace.management.id
  dcr_resource_group_name      = var.dcr_resource_group_name
}

# Derive the association scope id. If subscription_id is provided, use it; otherwise use the current authenticated subscription.
data "azurerm_client_config" "current" {}


locals {
  example_dcr_association_scope_id = var.subscription_id != "" ? "/subscriptions/${var.subscription_id}" : "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
