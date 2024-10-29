resource "azurerm_resource_group" "runtime_rg" {
  name     = local.runtime_resource_group_name
  location = local.location
}

resource "azurerm_resource_group" "data_rg" {
  name     = local.data_resource_group_name
  location = local.location
}