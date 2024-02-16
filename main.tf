locals {
  full_name = "${var.lob_name}${var.app_name}${var.microservice_name}${terraform.workspace}" # 1 microservice
  full_name2= "${var.lob_name1}${var.app_name1}${var.microservice_name1}${terraform.workspace}" # 2 microservice
  default_tags = {
    offername    = var.lob_name
    application  = var.app_name
    microservice = var.microservice_name
    offername1   = var.lob_name1
    application  = var.app_name1
    microservice = var.microservice_name1
    Description  = "Resource Terraformed for ${local.full_name}"
    Terraform    = "true"
  }
}

# resource "azurerm_resource_group" "rg" {
#   name     = "rg-${local.full_name}-01"
#   location = "France Central"
# }

data "azurerm_resource_group" "name" {
  name ="rg-emsspecbuilddev-01"
}

module "container_registry" {
  source        = "./Modules/Container_registry"
  acr_name      = "acr${local.full_name}01"
  rg_name       = data.azurerm_resource_group.name.name
  rg_location   = data.azurerm_resource_group.name.location
  sku           = "Premium" 
  admin_enabled = false
  subnet_id = module.virtual_network.snet_id
}

module "key_vault" {
  source                      = "./Modules/Key_vault"
  key_vault_name              = "kv${local.full_name}r01"
  rg_name                     = data.azurerm_resource_group.name.name
  rg_location                 = data.azurerm_resource_group.name.location
  user_assigned_identity_name = "mgdid${local.full_name}"
  #tenant_id                   = "6e51e1ad-c54b-4b39-b598-0ffe9ae68fef"
  soft_delete_retention_days  = "90"
  sku_name                    = "standard"
  subnet_id = module.virtual_network.snet_id
}

module "log_analytics_workspace" {
  source             = "./Modules/Log_Analytics_workspace"
  log_workspace_name = "lwn-${local.full_name}-01"
  rg_name            = data.azurerm_resource_group.name.name
  rg_location        = data.azurerm_resource_group.name.location
  sku                = "PerGB2018"
  retention_in_days  = 30
}

# module "sql_server" {
#   source                       = "./Modules/Sql_Server"
#   sql_server_name              = "sql-${local.full_name}-01"
#   rg_name                      = data.azurerm_resource_group.name.name
#   rg_location                  = data.azurerm_resource_group.name.location
#   administrator_login          = "SpecBuilder"
#   administrator_login_password = "PrasDF!@1234"
#   subnet_id = module.virtual_network.snet_id
# }

# module "sql_database1" {
#   source               = "./Modules/Sql_Database"
#   sql_database_name    = "sdb-${local.full_name}-01"
#   server_id            = module.sql_server.sql_server_id
#   min_capacity         = 20
#   max_size_gb          = 250
#   sku_name             = "S1"
#   storage_account_type = "Geo"
# }

# module "sql_database2" {
#   source               = "./Modules/Sql_Database"
#   sql_database_name    = "sdb-${local.full_name2}-01"
#   server_id            = module.sql_server.sql_server_id
#   min_capacity         = 20
#   max_size_gb          = 250
#   sku_name             = "S1"
#   storage_account_type = "Geo"
# }

# module "storage_account" {
#   source                   = "./Modules/Storage_account"
#   count                    = 3
#   storage_name             = "st${local.full_name}${count.index + 01}"
#   rg_name                  = data.azurerm_resource_group.name.name
#   rg_location              = data.azurerm_resource_group.name.location
#   account_replication_type = "RAGRS"
#   account_kind             = "StorageV2"
#   subnet_id = module.virtual_network.snet_id
# }

# module "storage_account1" {
#   source                   = "./Modules/Storage_account"
#   storage_name             = "st${local.full_name2}01"
#   rg_name                  = data.azurerm_resource_group.name.name
#   rg_location              = data.azurerm_resource_group.name.location
#   account_replication_type = "RAGRS"
#   account_kind             = "StorageV2"
#   subnet_id = module.virtual_network.snet_id
# }

module "kubernetes_cluster" {
  source               = "./Modules/AKS"
  cluster_name         = "aks-${local.full_name}-01"
  rg_name              = data.azurerm_resource_group.name.name
  rg_location          = data.azurerm_resource_group.name.location
  pool_name            = "agentpool"
  node_count           = 2
  vm_size              = "Standard_DS2_v2"
  os_sku               = "Ubuntu"
  orchestrator_version = "1.27.7"
  load_balancer_sku    = "standard"
  subnet_id = ""
}

module "application_gateway" {
  source                         = "./Modules/Application_gateway"
  rg_name                        = data.azurerm_resource_group.name.name
  rg_location                    = data.azurerm_resource_group.name.location
  public_ip_name                 = "pip-${local.full_name}01"
  pip_sku                        = "Standard"
  allocation_method              = "Static"
  AppGW_name                     = "appg-${local.full_name}-01"
  sku_name                       = "Standard_v2"
  sku_tier                       = "Standard_v2"
  autoscale_min_capacity         = 0
  autoscale_max_capacity         = 10
  gateway_ip_configuration       = "specbuilder-dev"
  subnet_id                      =  module.virtual_network.snet_id1
  frontend_port_name             = "specbuil-dev"
  frontend_port                  = 80
  frontend_ip_configuration_name = "frot-specbuilderdev"
  http_setting_name              = "specbuilder-hs"
  cookie_based_affinity          = "Disabled"
  backend_port                   = 80
  backend_protocol               = "Http"
  request_timeout                = 20
  listener_name                  = "specbuilder-ls"
  listener_protocol              = "Http"
  request_routing_rule_name      = "specbuilder-rule"
  priority                       = 9
  rule_type                      = "Basic"
  backend_address_pool_name      = "specbuilder-backend"
}

module "virtual_network" {
  source               = "./Modules/Virtual_Network_Snet"
  vnet_name            = "vnet-spoke-emdcesdit001-prod-fc-001"
  rg_name              = "rg-management-prod-fc"
  snet_name            = "privateEnd-snet"
  snet_address_prefix  = ["10.240.232.0/27"]
  snet1_name           = "appgw-snet"
  snet1_address_prefix = ["10.240.232.32/27"]
}

