terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "18b6fb7d-fae3-4420-8047-ae930ec89feb"
  tenant_id = "45289b7f-4357-472a-8a21-3da5b1cc14ae"
}

// Bar:
// Sub ID - 18b6fb7d-fae3-4420-8047-ae930ec89feb
// Tenant ID - 45289b7f-4357-472a-8a21-3da5b1cc14ae

// Victor:
// Sub ID - 
// Tenant ID -

// Niv:
// Sub ID - 
// Tenant ID -

// Russel:
// Sub ID - 
// Tenant ID -
