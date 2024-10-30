resource "azurerm_container_registry" "acr" {
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location

  anonymous_pull_enabled        = false
  public_network_access_enabled = false
  name                          = "${local.project_name}-${var.environment}-acr"
  sku                           = "Premium" #needed for private endpoints
  admin_enabled                 = false

  #checkov:skip=CKV_AZURE_164: Ensures that ACR uses signed/trusted images
  #checkov:skip=CKV_AZURE_165: Ensure geo-replicated container registries to match multi-region configurations
  #checkov:skip=CKV_AZURE_166: Ensure container image quarantine, scan, and mark images verified
  #checkov:skip=CKV_AZURE_167: Retentionpolicy changed in provider, checkov not your updated
  #checkov:skip=CKV_AZURE_237: Ensure container image quarantine, scan, and mark images verified
  #checkov:skip=CKV_AZURE_233: Ensure dedicated data endpoints are enabled < Not needed as we're using private endpoints to secure access
  zone_redundancy_enabled = false #changing this requires a new resource to be created

  retention_policy_in_days = 7
}

resource "azurerm_private_endpoint" "acr_pep" {
  resource_group_name = azurerm_resource_group.data_rg.name
  location            = azurerm_resource_group.data_rg.location

  name      = "${local.project_name}-${var.environment}-acr-pep"
  subnet_id = var.data_subnet_id
  private_service_connection {
    name                           = "${local.project_name}-${var.environment}-acr-pep-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
  }
}

resource "azurerm_private_dns_a_record" "pep_registry_a_record" {
  count               = length(azurerm_private_endpoint.acr_pep.custom_dns_configs)
  name                = lower(replace(azurerm_private_endpoint.acr_pep.custom_dns_configs[count.index].fqdn, ".azurecr.io", ""))
  zone_name           = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.data_rg.name
  ttl                 = 3600
  records             = azurerm_private_endpoint.acr_pep.custom_dns_configs[count.index].ip_addresses

  provider = azurerm.private-dns-subscription
}
