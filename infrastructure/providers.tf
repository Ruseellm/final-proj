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
#Configure Azurerm Provider
#When Copying Change Subscribtion and tenanat IDs 
provider "azurerm" {
  features {}
  subscription_id = "18b6fb7d-fae3-4420-8047-ae930ec89feb" 
  tenant_id = "45289b7f-4357-472a-8a21-3da5b1cc14ae"
}

// Bar:
// Sub ID - 18b6fb7d-fae3-4420-8047-ae930ec89feb
// Tenant ID - 45289b7f-4357-472a-8a21-3da5b1cc14ae

// Victor:
// Sub ID - 826acb01-6bc8-47eb-815e-8afd69055ea2
// Tenant ID - f06ae6a4-edc9-47f1-a02b-d4158c202cf3

// Niv:
// Sub ID - 
// Tenant ID -

// Russel:
// Sub ID - 
// Tenant ID -
