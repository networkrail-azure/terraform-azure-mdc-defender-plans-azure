data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

resource "azapi_update_resource" "asc_plans" {
  for_each = local.enabled_plans_map

  type        = "Microsoft.Security/pricings@2024-01-01"
  resource_id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Security/pricings/${each.value}"

  body = {
    properties = {
      pricingTier = var.default_tier
      subPlan     = lookup(var.subplans, each.key, each.key == "StorageAccounts" ? "DefenderForStorageV2" : var.default_subplan)
      extensions  = local.plan_extensions[each.key]
    }
  }
}
