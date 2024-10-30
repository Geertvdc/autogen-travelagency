resource "azurerm_cognitive_account" "main" {
  name                = "${project_name}-${var.environment}-cognitive"
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location
  kind                = "OpenAI"
  sku_name            = "S0"
  public_network_access_enabled = false
}

resource "azurerm_cognitive_deployment" "gpt4o" {
  name                 = "${project_name}-${var.environment}-cd"
  cognitive_account_id = azurerm_cognitive_account.example.id
  model {
    format  = "OpenAI"
    name    = "gpt-4o"
    version = "2024-05-13"
  }

  sku {
    name = "GlobalStandard"
    capacity = 10
  }
}

resource "azurerm_private_endpoint" "cognitive_account_pep" {
  name                = "${project_name}-${var.environment}-cognitive-pep"
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "${project_name}-${var.environment}-cognitive-pep-psc"
    private_connection_resource_id = azurerm_cognitive_account.main.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}

# resource "azurerm_private_dns_a_record" "pep_cognitive_a_record" {
#   count               = length(azurerm_private_endpoint.cognitive_account_pep.custom_dns_configs)
#   name                = lower(replace(azurerm_private_endpoint.cognitive_account_pep.custom_dns_configs[count.index].fqdn, "privatelink.openai.azure.com", ""))
#   zone_name           = "privatelink.openai.azure.com"
#   resource_group_name = azurerm_resource_group.data_rg.name
#   ttl                 = 3600
#   records             = azurerm_private_endpoint.cognitive_account_pep.custom_dns_configs[count.index].ip_addresses

#   provider = azurerm.private-dns-subscription
# }