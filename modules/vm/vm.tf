data "azurerm_resource_group" "rg" {
  name = var.vm_rg_id
}

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

# Create public IP
resource "azurerm_public_ip" "ip" {
  name                = "${var.vm_prefix}-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.vm_tags
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_prefix}-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = var.vm_tags

  ip_configuration {
    name                          = "nic-config"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.vm_sg_id
}

#
# Create virtual machine
# See: https://gmusumeci.medium.com/how-to-deploy-a-red-hat-enterprise-linux-rhel-vm-in-azure-using-terraform-90f3d413c783
#
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${var.vm_prefix}-vm"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  source_image_id       = var.vm_image_id
  tags                  = var.vm_tags

  admin_ssh_key {
    username   = var.vm_user
    public_key = var.vm_pubkey
  }

  os_disk {
    name                 = "${var.vm_prefix}-disk"
    caching              = "ReadWrite"
    storage_account_type = var.vm_storage_account_type
    disk_size_gb         = var.vm_storage_size_gb
  }

  plan {
    publisher = var.vm_plan.publisher
    product   = var.vm_plan.product
    name      = var.vm_plan.name
  }

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == null ? [1] : []
    content {
      publisher = var.vm_image_info.publisher
      offer     = var.vm_image_info.offer
      sku       = var.vm_image_info.sku
      version   = var.vm_image_info.version
    }
  }

  computer_name                   = var.vm_name
  admin_username                  = var.vm_user
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  custom_data = var.vm_custom_data

  lifecycle {
    ignore_changes = [custom_data]
  }
}

