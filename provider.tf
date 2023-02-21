terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "xantara-it-rg"
    storage_account_name = "xantaraitsz5l0cpd"
    container_name       = "tfstate"
    key                  = "az-demo.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e66b35da-90dd-4119-847f-645ae35f58ce"
  tenant_id       = "1004b2bb-1ea9-4e2c-9edc-aaa47d5ba8c9"
}
