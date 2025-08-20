// Create a Data Collection Rule when telemetry is enabled
// and the user opts in via `var.create_dcr`. This uses an existing Log Analytics workspace
// provided via `var.dcr_workspace_resource_id`.

locals {
  should_create_dcr = var.enable_telemetry && var.create_dcr
}

resource "azurerm_resource_group" "dcr" {
  count    = local.should_create_dcr ? 1 : 0
  name     = var.dcr_resource_group_name
  location = var.location
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  count               = local.should_create_dcr ? 1 : 0
  name                = var.dcr_name
  resource_group_name = local.should_create_dcr ? azurerm_resource_group.dcr[0].name : null
  location            = var.location

  // Minimal data sources and a log_analytics destination for example purposes.
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
      workspace_resource_id = var.dcr_workspace_resource_id
    }
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["la"]
  }
}
