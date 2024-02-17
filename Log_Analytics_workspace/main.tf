
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_workspace_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
}