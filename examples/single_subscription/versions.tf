terraform {
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = ">= 0.1.8, < 1.0"
    }
  }
}

provider "azurerm" {
  features {}
  # use the example variable when provided to target a specific subscription
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}

provider "modtm" {
  enabled = false
}
