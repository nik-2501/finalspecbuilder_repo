variable "lb_name" {
 description = "Name of loaadbalancer"
  type =string
}

variable "sku1" {
  description = "The SKU (tier) of the Event Hub namespace (e.g., Standard, Basic)"
  type        = string
}
variable "resource_group_name" {
  type    = string
}
 
variable "location" {
  type    = string
  default = "westeurope"
}

#  variable "pip_infrastructure_core_app_production" {
#   description = "The ID of the associated public IP address, if any. Set to null if not using a public IP."
#   type    = string
# }

# variable "allocation_method_lb"{
#   description = "loadbalancer"
#   type = string
# }

variable "backend_addpool_name"{
  description = "privet_loadbalancer"
  type = string
}
variable "rule_name"{
  description = "privet_loadbalancer"
  type = string
}
variable "protocol_name"{
  description = "privet_loadbalancer"
  type = string
}
variable "front_port_number"{
  description = "privet_loadbalancer"
  type = number
}
variable "back_port_number"{
  description = "privet_loadbalancer"
  type = number
}
variable "prob_name"{
  description = "privet_loadbalancer"
  type = string
}
variable "prob_name_protocol"{
  description = "privet_loadbalancer"
  type = string
}
variable "prob_port_number"{
  description = "privet_loadbalancer"
  type = number
}
variable "frontend_ip_configuration_name" {
  type = string
}

variable "subnet_id" {
  type = string
}
