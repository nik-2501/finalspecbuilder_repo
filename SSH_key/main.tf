resource "azurerm_ssh_public_key" "ssh_key" {
  name                = var.ssh_key_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  public_key          = var.public_key
}