resource "azurerm_container_app_environment" "main" {
  name                               = local.containerapp_env_name
  resource_group_name                = azurerm_resource_group.runtime_rg.name
  location                           = azurerm_resource_group.runtime_rg.location
  internal_load_balancer_enabled     = true
  infrastructure_subnet_id           = var.aca_subnet_id
  log_analytics_workspace_id         = 
  infrastructure_resource_group_name = "${local.containerapp_env_name}-rg"

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}