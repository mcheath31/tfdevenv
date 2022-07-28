terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  #Make a separate Resource group for your state files
  backend "azurerm" {
    resource_group_name  = "Your RG name here"
    storage_account_name = "Your Storage Account here"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Configure Resource Group
resource "azurerm_resource_group" "mtc_resources" {
  name     = "Your RG name"
  location = "East US 2"

  tags = {
    "environment" = "dev"
  }
}


data "azurerm_public_ip" "mtc-ip-data" {
  name                = azurerm_public_ip.mtc-publicip.name
  resource_group_name = azurerm_resource_group.mtc_resources.name

}

output "public_ip_addr" {
  value = "${azurerm_linux_virtual_machine.mtc-vm.name}: ${data.azurerm_public_ip.mtc-ip-data.ip_address}"
}