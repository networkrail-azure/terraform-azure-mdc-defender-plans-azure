module "mdc_plans_enable" {
  source           = "../.."
  subscription_id  = var.subscription_id
  mdc_plans_list   = var.mdc_plans_list
  subplans         = var.subplans
  enable_telemetry = var.enable_telemetry
  dcr_association_scope_id     = local.example_dcr_association_scope_id
}
locals {
  example_dcr_association_scope_id = "/subscriptions/${var.subscription_id}"
}
