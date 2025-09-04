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
  backend "azurerm" {
    
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "modtm" {
  enabled = false
}
