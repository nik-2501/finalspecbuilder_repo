resource "azurerm_log_analytics_solution" "example" {
  solution_name         = var.solution_name
  location              = var.rg_location
  resource_group_name   = var.rg_name
  workspace_resource_id = var.workspace_resource_id
  workspace_name        = var.workspace_name

  plan {
    publisher = "Microsoft"
    promotion_code = ""
    product   = "OMSGallery/ContainerInsights"
  }
}