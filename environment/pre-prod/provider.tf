terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "raju"
    storage_account_name = "raju32456"
    container_name       = "raju"
    key                  = "vm.tfstate"
  }
}
provider "azurerm" {
  features {}

}