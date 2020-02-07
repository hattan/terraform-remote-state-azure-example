provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
}

terraform {
  required_version = "~> 0.12"
  backend "azurerm" {
  }
}

resource "azurerm_resource_group" "demo_resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "demo_vnet" {
  name                = "${azurerm_resource_group.demo_resource_group.name}vnet"
  address_space       = ["${var.network-range}.0.0/16"]
  location            = azurerm_resource_group.demo_resource_group.location
  resource_group_name = azurerm_resource_group.demo_resource_group.name
}

resource "azurerm_subnet" "demo_subnet" {
  name                 = "${azurerm_resource_group.demo_resource_group.name}subnet"
  resource_group_name  = azurerm_resource_group.demo_resource_group.name
  virtual_network_name = azurerm_virtual_network.demo_vnet.name
  address_prefix       = "${var.network-range}.1.0/26"
}