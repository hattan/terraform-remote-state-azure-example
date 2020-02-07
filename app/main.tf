provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.38.0"
}

terraform {
  required_version = "~> 0.12"
  backend "azurerm" {
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    storage_account_name  = var.network_storage_account_name
    container_name        = var.network_container_name
    key                   = var.network_storage_key
    access_key            = var.network_access_key
  }
}

resource "azurerm_resource_group" "demo_app_resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_public_ip" "demo-vm-ip" {
  name                = "${azurerm_resource_group.demo_app_resource_group.name}-ip"
  location            = azurerm_resource_group.demo_app_resource_group.location
  resource_group_name = azurerm_resource_group.demo_app_resource_group.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "demo-vm-nic" {
  name                = "${azurerm_resource_group.demo_app_resource_group.name}-nic"
  location            = azurerm_resource_group.demo_app_resource_group.location
  resource_group_name = azurerm_resource_group.demo_app_resource_group.name

  ip_configuration {
    name                          = "democonfig"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.demo-vm-ip.id
  }
}

resource "azurerm_virtual_machine" "demo-vm" {
  name                  = "${azurerm_resource_group.demo_app_resource_group.name}-vm"
  location              = "${azurerm_resource_group.demo_app_resource_group.location}"
  resource_group_name   = "${azurerm_resource_group.demo_app_resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.demo-vm-nic.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
   delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "demo"
  }
}