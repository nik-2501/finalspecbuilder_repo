resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_id
  sku                 = var.sku1
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method_publicip
}