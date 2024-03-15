#
# Create a resource group
#

# Create (and display) an SSH key
resource "tls_private_key" "private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.name_prefix}-rg"
  tags     = var.tags
}

# Template for bootstrapping
data "template_file" "linux-vm-cloud-init" {
  template = templatefile("cloud-init.txt.tftpl", {
    username = var.rhsm_username
    password = var.rhsm_password
    pool     = var.rhsm_pool
  })
}


data "azurerm_shared_image_version" "image" {
  name                = var.linux_vm_gallery_image.version
  image_name          = var.linux_vm_gallery_image.name
  resource_group_name = var.linux_vm_gallery_image.resource_group
  gallery_name        = var.linux_vm_gallery_image.gallery

  sort_versions_by_semver = true
}

module "vm_cmk" {
  source = "./modules/vm"

  vm_count    = var.linux_vm_count
  vm_name     = "demo"
  vm_prefix   = "demo"
  vm_pubkey   = tls_private_key.private_ssh_key.public_key_openssh
  vm_image_id = data.azurerm_shared_image_version.image.id
  vm_plan = {
    publisher = "redhat"
    product   = "rhel-byos"
    name      = "rhel-lvm86-gen2"
  }

  vm_rg_id     = azurerm_resource_group.rg.name
  vm_subnet_id = azurerm_subnet.snet.id
  vm_sg_id     = azurerm_network_security_group.nsg.id

  vm_custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
}

resource "azurerm_marketplace_agreement" "rhel_93" {
  publisher = "redhat"
  offer     = "rhel-byos"
  plan      = "rhel-lvm93-gen2"
}

data "azurerm_platform_image" "rhel" {
  location  = "West Europe"
  publisher = "RedHat"
  offer     = "rhel-byos"
  sku       = "rhel-lvm93-gen2"
}

module "vm_rhel" {
  source = "./modules/vm"

  vm_count      = 0
  vm_name       = "db-demo"
  vm_prefix     = "db_demo"
  vm_pubkey     = tls_private_key.private_ssh_key.public_key_openssh
  vm_image_info = data.azurerm_platform_image.rhel
  vm_plan = {
    publisher = "redhat"
    product   = "rhel-byos"
    name      = "rhel-lvm93-gen2"
  }

  vm_rg_id     = azurerm_resource_group.rg.name
  vm_subnet_id = azurerm_subnet.snet.id
  vm_sg_id     = azurerm_network_security_group.nsg.id

  vm_custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)
}
