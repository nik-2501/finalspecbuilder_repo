# resource "azurerm_virtual_network" "vnet" {
#   name                = var.vnet_name
#   location            = var.rg_location
#   resource_group_name = var.rg_name
#   address_space       = var.address_space

# }

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "snet" {
  name = var.snet_name
  resource_group_name = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes = var.snet_address_prefix
}
resource "azurerm_subnet" "snet1" {
  name = var.snet1_name
  resource_group_name = var.rg_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes = var.snet1_address_prefix
}

# resource "azurerm_subnet" "snet2" {
#   name = var.snet2_name
#   resource_group_name = var.rg_name
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
#   address_prefixes = var.snet2_address_prefix
# }

