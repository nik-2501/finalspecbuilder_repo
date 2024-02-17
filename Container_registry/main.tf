resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  public_network_access_enabled = false
  export_policy_enabled = false
  network_rule_set {
    default_action = "Deny"
  }
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "pe-acr-sepc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-acr-spec-01"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names               = ["registry"]
    is_manual_connection           = false
  }
}

# resource "azurerm_app_service_virtual_network_swift_connection" "vnet_int_wap3" {
#   app_service_id = azurerm_container_registry.acr.id
#   subnet_id      = var.subnet_id
# }