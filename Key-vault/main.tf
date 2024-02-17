# Create managed identity
resource "azurerm_user_assigned_identity" "specbuilder-mgd-id" {
  name                = var.user_assigned_identity_name
  location            = var.rg_location
  resource_group_name = var.rg_name
}

data "azurerm_client_config" "current" {}

#Create Key vault 
resource "azurerm_key_vault" "key_vault" {
  name                        = var.key_vault_name
  location                    = var.rg_location
  resource_group_name         = var.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = false
  public_network_access_enabled = false
  sku_name = var.sku_name

network_acls {
  bypass = "AzureServices"
  default_action = "Deny"
}

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.specbuilder-mgd-id.principal_id

    key_permissions = [
     "Get","List",
    ]

    secret_permissions = [
      "Get","List",
    ]

    certificate_permissions = [
      "Get","Update", "GetIssuers", "Import", "List", "ListIssuers", 
    ]
    
  }
}

resource "azurerm_private_endpoint" "endpoint" {
  name                = "pe-kv-spec-02"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-kv-spec-02"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

# resource "azurerm_app_service_virtual_network_swift_connection" "vnet_int_wap3" {
#   app_service_id = azurerm_key_vault.key_vault.id
#   subnet_id      = var.subnet_id
# }

