resource "azurerm_mssql_database" "sql_database" {
  name           = var.sql_database_name
  server_id      = var.server_id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  min_capacity   = var.min_capacity
  max_size_gb    = var.max_size_gb
  read_scale     = false
  sku_name       = var.sku_name
  zone_redundant = false
  storage_account_type = var.storage_account_type
  
}