resource "azurerm_user_assigned_identity" "app-gw-identity" {
  resource_group_name = var.rg_name
  location            = var.rg_location
  name                = var.AppGW_name
}

# resource "azurerm_public_ip" "pip" {
#   name                = var.public_ip_name
#   resource_group_name = var.rg_name
#   location            = var.rg_location
#   allocation_method   = var.allocation_method
#   sku                 =  var.pip_sku
# }

resource "azurerm_application_gateway" "AppGW" {
  name                = var.AppGW_name
  resource_group_name = var.rg_name
  location            = var.rg_location

  sku {
    name     = var.sku_name
    tier     = var.sku_tier
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app-gw-identity.id]
  }

  autoscale_configuration {
    min_capacity = var.autoscale_min_capacity
    max_capacity = var.autoscale_max_capacity
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration
    subnet_id = var.subnet_id
  }

  frontend_port {
    name = var.frontend_port_name
    port = var.frontend_port
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    subnet_id            = var.subnet_id
    # public_ip_address_id = azurerm_public_ip.pip.id
    # private_ip_address   = var.private_ip_address
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = var.cookie_based_affinity
    port                  = var.backend_port
    protocol              = var.backend_protocol
    request_timeout       = var.request_timeout
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = var.listener_protocol
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    priority                   = var.priority
    rule_type                  = var.rule_type
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
  }
}