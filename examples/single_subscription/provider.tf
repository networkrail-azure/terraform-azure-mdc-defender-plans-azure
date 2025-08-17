provider "azurerm" {
  alias = "target"
  features {}
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}
