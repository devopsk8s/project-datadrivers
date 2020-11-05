terraform {
  required_version = "~> 0.13"
  backend "azurerm" {
  #     resource_group_name  = <resource_group_name>
  #     storage_account_name = <storage_account_name>
  #     container_name       = <container_name>
  #     key                  = <key>
  }
}

# Configure the Azure provider
provider "azurerm" {
  version = "~> 2.30.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  environment = "public"
}

provider "azuread" {
  version = "~> 1.0.0"
}

provider "random" {
  version = "~> 3.0"
}