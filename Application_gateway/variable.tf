variable "AppGW_name" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "sku_name" {
  type = string
}
variable "sku_tier" {
  type = string
}
variable "autoscale_min_capacity" {
  type = number
}
variable "autoscale_max_capacity" {
  type = number
}
variable "gateway_ip_configuration" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "frontend_port_name" {
  type = string
}
variable "frontend_port" {
  type = number
}
variable "frontend_ip_configuration_name" {
  type = string
}

# variable "private_ip_address" {
#  type = string
# }

variable "backend_address_pool_name" {
  type = string
}
variable "http_setting_name" {
  type = string
}
variable "cookie_based_affinity" {
  type = string
}

variable "backend_port" {
  type = number
}
variable "backend_protocol" {
  type = string
}
variable "request_timeout" {
  type = number
}
variable "listener_name" {
  type = string
}
variable "listener_protocol" {
  type = string
}
variable "request_routing_rule_name" {
  type = string
}
variable "priority" {
  type = string
}
variable "rule_type" {
  type = string
}
variable "public_ip_name" {
  type = string
}
variable "pip_sku" {
  type = string
}
variable "allocation_method" {
  type = string
}
