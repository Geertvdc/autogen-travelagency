resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.project_name}-${var.environment}-log"
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location
  retention_in_days   = 180
  sku                 = "PerGB2018"
}

resource "azurerm_application_insights" "main" {
  name                = "${local.project_name}-${var.environment}-appi"
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id

}