terraform {
  backend "azurerm" {
    # Provided values
    resource_group_name  = "rg-acd-mgmt-state-uksouth-001"
    storage_account_name = "stoacdmgmuks001bsjl"
    container_name       = "mgmt-tfstate"
    key                  = "single_subscription/Defender.tfstate"
  # Prefer Azure AD authentication to avoid requiring storage account keys.
  # When set to true, Terraform will use the Azure CLI / Managed Identity creds
  # and will NOT call storageAccounts/listKeys; instead the identity must have
  # the appropriate RBAC permission to access blobs (Storage Blob Data Contributor
  # or greater) on the storage account or container.
  use_azuread_auth = true
  }
}

