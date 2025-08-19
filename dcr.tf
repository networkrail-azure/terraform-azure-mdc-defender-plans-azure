resource "azurerm_monitor_data_collection_rule_association" "this" {
  # Create association only when both IDs are provided and non-empty.
  count = (var.existing_dcr_id != null && var.existing_dcr_id != "" && var.dcr_association_scope_id != null && var.dcr_association_scope_id != "") ? 1 : 0

  name                    = "mdc-dcr-association"
  data_collection_rule_id = var.existing_dcr_id
  target_resource_id      = var.dcr_association_scope_id
}
