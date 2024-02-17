# resource "azurerm_public_ip" "public_ip1" {
#   name                = var.pip_infrastructure_core_app_production
#   sku                 = var.sku1
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = var.allocation_method_lb
# }
resource "azurerm_lb" "lb1" {
  name                = var.lb_name
  sku                 = var.sku1
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name = var.frontend_ip_configuration_name
    subnet_id = var.subnet_id  
  }
}
resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name                = var.backend_addpool_name
  loadbalancer_id = azurerm_lb.lb1.id
}
 
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb1.id
  name                           = var.rule_name
  protocol                       = var.protocol_name
  frontend_port                  = var.front_port_number
  backend_port                   = var.back_port_number
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
}
 
resource "azurerm_lb_probe" "lb_probe" {
  name                = var.prob_name
  loadbalancer_id     = azurerm_lb.lb1.id
  protocol            = var.prob_name_protocol
  port                = var.prob_port_number
}


