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

#
# Create virtual machine
# See: https://gmusumeci.medium.com/how-to-deploy-a-red-hat-enterprise-linux-rhel-vm-in-azure-using-terraform-90f3d413c783
#
resource "azurerm_linux_virtual_machine" "vm" {
  count                           = 1
  name                            = "${var.name_prefix}-vm"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  tags                            = var.tags
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = var.linux_vm_size


  source_image_id = var.linux_vm_image_id != "" ? var.linux_vm_image_id : null
  dynamic "source_image_reference" {
    for_each = var.linux_vm_image_id == "" ? [1] : []
    content {
      publisher = var.linux_vm_image_publisher
      offer     = var.linux_vm_image_offer
      sku       = var.linux_vm_image_sku
      version   = "latest"
    }
  }

  os_disk {
    name                          = "${var.name_prefix}-disk"
    caching                       = "ReadWrite"
    storage_account_type          = var.linux_vm_storage_account_type
    disk_size_gb                  = var.linux_vm_storage_size_gb
  }

  computer_name                   = "${var.name_vm}"
  admin_username                  = "${var.name_user}"
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  admin_ssh_key {
    username                      = "${var.name_user}"
    public_key                    = tls_private_key.private_ssh_key.public_key_openssh
  }
  
  custom_data                     = base64encode(data.template_file.linux-vm-cloud-init.rendered)
}

# Template for bootstrapping
data "template_file" "linux-vm-cloud-init" {
  template = templatefile("cloud-init.txt.tftpl", {
    username = var.rhsm_username
    password = var.rhsm_password
  })
}

# resource "azurerm_image" "img" {
#   name                      = "${var.name_prefix}-img"
#   location                  = azurerm_resource_group.example.location
#   resource_group_name       = "xantara-it-rg"
#   source_virtual_machine_id = azurerm_virtual_machine.example.id
# }
