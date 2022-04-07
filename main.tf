terraform {
  required_version = ">= 0.13"

  required_providers{
      azurerm = {
          source  = "hashicorp/azurerm"
          version = ">= 2.26"
      }
  }
}

provider "azurerm" {
    features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

}

resource "azurerm_resource_group" "rg_atividade" {
  name     = "resourceGroup"
  location = "brazilsouth"
}

