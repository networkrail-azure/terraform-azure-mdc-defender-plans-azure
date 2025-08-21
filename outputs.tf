output "plans_details" {
  description = "All plans details"
  value = {
    for name, pricing in local.asc_plans : name => {
      id      = pricing.id
      subplan = jsondecode(pricing.output).properties.subPlan
    }
  }
}

output "subscription_pricing_id" {
  description = "The subscription pricing ID"
  value       = { for plan, pricing in local.asc_plans : plan => pricing.id }
}

