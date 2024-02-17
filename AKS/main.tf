resource "azurerm_private_dns_zone" "aks_dns" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = var.rg_location
}

resource "azurerm_user_assigned_identity" "identity" {
  name                = "aks-spec-identity"
  resource_group_name = var.rg_name
  location            = var.rg_location
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_private_dns_zone.aks_dns.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.identity.id
}

resource "azurerm_kubernetes_cluster" "tf-specbuilder-aks" {
    name                = var.cluster_name
    location            = var.rg_location
    resource_group_name = var.rg_name
    dns_prefix          = "specbuilder-aks-dns"
    private_cluster_enabled = true
    local_account_disabled = true
    private_dns_zone_id     = azurerm_private_dns_zone.aks_dns.id
    
    
    default_node_pool {
        name            = var.pool_name
        node_count      = var.node_count
        zones           = ["1", "2", "3"]
        vm_size         = var.vm_size
        orchestrator_version = var.orchestrator_version
        os_sku = var.os_sku
        enable_host_encryption = true
    }

    network_profile {
    load_balancer_sku = var.load_balancer_sku
    network_plugin = "azure"
    network_plugin_mode = "overlay"
    outbound_type = "userDefinedRouting"
    }

    ingress_application_gateway {
      subnet_id = var.subnet_id
    }

}