resource "azurerm_user_assigned_identity" "identity" {
  name                = "sql-admin"
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.rg_location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  public_network_access_enabled = false
  azuread_administrator {
    login_username = azurerm_user_assigned_identity.identity.name
    object_id =  azurerm_user_assigned_identity.identity.principal_id
    azuread_authentication_only = true
  }

}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "pe-sql-spec-03"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "pse-sql-spec-03"
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names = ["sqlServer"]
    is_manual_connection           = false
  }
}

# resource "azurerm_app_service_virtual_network_swift_connection" "vnet_int_wap3" {
#   app_service_id = azurerm_mssql_server.sql_server.id
#   subnet_id      = var.subnet_id
# }