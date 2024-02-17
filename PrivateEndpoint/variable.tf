variable "rg_name" {
  type = string
}

variable "rg_location" {
  type = string
}

variable "private_endpoint_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_connection_name" {
  type = string
}

variable "private_connection_resource_id" {
  type = string
}
variable "subresource_names" {
  type = list(string)
}