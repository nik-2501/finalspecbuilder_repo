resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  enable_https_traffic_only       = true
  public_network_access_enabled = false
  cross_tenant_replication_enabled = false
  allow_nested_items_to_be_public = false

  network_rules {
      default_action             = "Deny"
      bypass                     = ["AzureServices", "Logging"]
      ip_rules                   = ["192.1.1.1"]
  }
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "pe-stg-sepc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-acr-spec-01"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names               = ["blod"]
    is_manual_connection           = false
  }
}

# resource "azurerm_app_service_virtual_network_swift_connection" "vnet_int_wap3" {
#   app_service_id = azurerm_storage_account.storage.id
#   subnet_id      = var.subnet_id
# }