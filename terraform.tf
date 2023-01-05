terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.37.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.1.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}