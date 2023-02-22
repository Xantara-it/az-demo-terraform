# Generate random password
resource "random_password" "password" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric          = true
  special          = true
  override_special = "!@#$%&"
}

# Create (and display) an SSH key
resource "tls_private_key" "private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = 1
  name                  = "${var.name_prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  tags                  = var.tags
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "${var.name_prefix}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "${var.name_prefix}"
  admin_username                  = "${var.name_user}"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "${var.name_user}"
    public_key = tls_private_key.private_ssh_key.public_key_openssh
  }
}

# resource "azurerm_image" "img" {
#   name                      = "${var.name_prefix}-img"
#   location                  = azurerm_resource_group.example.location
#   resource_group_name       = "xantara-it-rg"
#   source_virtual_machine_id = azurerm_virtual_machine.example.id
# }
