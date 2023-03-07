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
  count                 = var.linux_vm_count
  name                  = "${var.name_prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  tags                  = var.tags
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.linux_vm_size
  source_image_id       = data.azurerm_shared_image_version.image.id

  admin_ssh_key {
    username   = var.name_user
    public_key = tls_private_key.private_ssh_key.public_key_openssh
  }

  os_disk {
    name                 = "${var.name_prefix}-disk"
    caching              = "ReadWrite"
    storage_account_type = var.linux_vm_storage_account_type
    disk_size_gb         = var.linux_vm_storage_size_gb
  }

  plan {
    publisher = var.linux_vm_plan.publisher
    product   = var.linux_vm_plan.product
    name      = var.linux_vm_plan.name
  }

  computer_name                   = var.name_vm
  admin_username                  = var.name_user
  admin_password                  = random_password.password.result
  disable_password_authentication = false

  custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
}

data "azurerm_shared_image_version" "image" {
  name                = var.linux_vm_gallery_image.version
  image_name          = var.linux_vm_gallery_image.name
  resource_group_name = var.linux_vm_gallery_image.resource_group
  gallery_name        = var.linux_vm_gallery_image.gallery

  sort_versions_by_semver = true
}

# Template for bootstrapping
data "template_file" "linux-vm-cloud-init" {
  template = templatefile("cloud-init.txt.tftpl", {
    username = var.rhsm_username
    password = var.rhsm_password
  })
}
