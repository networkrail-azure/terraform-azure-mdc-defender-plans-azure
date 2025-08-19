module "mdc_plans_enable" {
  source           = "../.."
  mdc_plans_list   = var.mdc_plans_list
  subplans         = var.subplans
  enable_telemetry = var.enable_telemetry

  # Opt-in AMA DCR wiring to a central workspace
  # Associate an existing DCR by providing its resource id and the target scope
  existing_dcr_id            = var.existing_dcr_id
  dcr_association_scope_id   = local.example_dcr_association_scope_id
}

# Derive the association scope id. If subscription_id is provided, use it; otherwise use the current authenticated subscription.
data "azurerm_client_config" "current" {}


locals {
  example_dcr_association_scope_id = var.subscription_id != "" ? "/subscriptions/${var.subscription_id}" : "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
}
