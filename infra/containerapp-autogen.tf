resource "azurerm_container_app" "autogen_app" {
  depends_on = [
    azurerm_role_assignment.ui_acr_pull
  ]

  name                         = local.ui_container_app_name
  resource_group_name          = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode                = "Single"
  workload_profile_name        = "D4"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ui_container_app_identity.id]
  }

  registry {
    server   = data.azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.ui_container_app_identity.id
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = local.ui_container_app_name
      image  = var.ui_container_app_image_path
      cpu    = var.ui_container_app_cpu
      memory = var.ui_container_app_memory

      env {
        name  = "VITE_APPLICATIONINSIGHTS_CONNECTION_STRING"
        value = data.azurerm_application_insights.baseplane.connection_string
      }

      env {
        name  = "VITE_RINGFENCE_API_URL"
        value = local.api_url
      }

      env {
        name  = "VITE_CLIENT_ID"
        value = var.ui_client_id
      }

      env {
        name  = "VITE_API_CLIENT_ID"
        value = var.api_client_id
      }

      env {
        name  = "VITE_API_IDENTIFIER_URI"
        value = var.api_identifier_uri
      }
    }
  }

  ingress {
    target_port      = 80
    external_enabled = true

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_user_assigned_identity" "autogen_app_identity" {
  resource_group_name = azurerm_resource_group.runtime_rg.name
  location            = azurerm_resource_group.runtime_rg.location
  name                = "autogen-${var.environment}-uai"
}

resource "azurerm_role_assignment" "autogen_app_acr_pull" {
  scope                = 
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.autogen_app_identity.principal_id
}
