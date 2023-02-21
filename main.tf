#
# Create a resource group
#
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.name_prefix}-rg"
  tags     = var.tags
}

#
# Create a public IP
#
resource "azurerm_public_ip" "ip" {
  name                = "${var.name_prefix}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
