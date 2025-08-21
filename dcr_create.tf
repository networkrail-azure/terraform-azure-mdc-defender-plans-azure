locals {
  should_create_dcr = var.enable_telemetry
  
  # Auto-generate names using region
  dcr_name                = "dcr-mdc-${var.location}"
  dcr_resource_group_name = "rg-mdc-dcr-${var.location}"
}
data "azurerm_log_analytics_workspace" "management" {
  name                = "law-management-uksouth"
  resource_group_name = "rg-management-uksouth"
}

resource "azurerm_resource_group" "dcr" {
  count    = local.should_create_dcr ? 1 : 0
  name     = local.dcr_resource_group_name
  location = var.location
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  count               = local.should_create_dcr ? 1 : 0
  name                = local.dcr_name
  resource_group_name = local.should_create_dcr ? azurerm_resource_group.dcr[0].name : null
  location            = var.location

  data_sources {
    windows_event_log {
      name     = "weblogs"
      streams  = ["Microsoft-Event"]
  x_path_queries = ["*"]
    }
  }

  destinations {
    log_analytics {
      name                  = "la"
      workspace_resource_id = data.azurerm_log_analytics_workspace.management.id
    }
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["la"]
  }
}
