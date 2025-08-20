resource "azurerm_monitor_data_collection_rule_association" "this" {
  # Create association only when we created a DCR and have a target scope id.
  count = (local.should_create_dcr && var.dcr_association_scope_id != null && var.dcr_association_scope_id != "") ? 1 : 0

  name                    = "mdc-dcr-association"
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr[0].id
  target_resource_id      = var.dcr_association_scope_id
}
