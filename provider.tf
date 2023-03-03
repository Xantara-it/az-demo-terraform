terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
  }

  backend "azurerm" {
    container_name = "tfstate"
    key            = "az-demo.tfstate"
  }
}

provider "azurerm" {
  features {}
}
