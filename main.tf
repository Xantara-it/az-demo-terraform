#
# Create a resource group
#
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

# Create (and display) an SSH key
resource "tls_private_key" "private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "vm_cmk" {
  source = "./modules/vm"

  vm_count      = 1
  vm_name       = "demo"
  vm_prefix     = "demo"
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

  vm_tags = merge(var.tags, {
    role = "cmk-server"
  })

  depends_on = [
    azurerm_resource_group.rg
  ]
}