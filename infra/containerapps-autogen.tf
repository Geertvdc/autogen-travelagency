# resource "azurerm_container_app" "agenthost_app" {
#   depends_on = [
#     azurerm_role_assignment.agenthost_app_acr_pull
#   ]

#   name                         = "${local.project_name}-${var.environment}-agenthost-app"
#   resource_group_name          = azurerm_resource_group.runtime_rg.name
#   container_app_environment_id = azurerm_container_app_environment.main.id
#   revision_mode                = "Single"
#   workload_profile_name        = "consumption"

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.agenthost_app_identity.id]
#   }

#   registry {
#     server   = azurerm_container_registry.acr.login_server
#     identity = azurerm_user_assigned_identity.agenthost_app_identity.id
#   }

#   template {
#     min_replicas = 1
#     max_replicas = 5

#     container {
#       name   = "agenthost"
#       image  = "${azurerm_container_registry.acr.login_server}/agenthost:latest"
#       cpu    = 0.5
#       memory = "0.5Gi"

#       # env {
#       #   name  = "ENV_VARIABLE_NAME"
#       #   value = "value"
#       # }
#     }
#   }

#   ingress {
#     target_port      = 80
#     external_enabled = false

#     traffic_weight {
#       percentage      = 100
#       latest_revision = true
#     }
#   }
# }

resource "azurerm_user_assigned_identity" "agenthost_app_identity" {
  resource_group_name = azurerm_resource_group.runtime_rg.name
  location            = azurerm_resource_group.runtime_rg.location
  name                = "agenthost-${var.environment}-uai"
}

resource "azurerm_role_assignment" "agenthost_app_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.agenthost_app_identity.principal_id
}

# resource "azurerm_container_app" "qdrant_app" {
#   depends_on = [
#     azurerm_role_assignment.qdrant_app_acr_pull
#   ]

#   name                         = "${local.project_name}-${var.environment}-qdrant-app"
#   resource_group_name          = azurerm_resource_group.runtime_rg.name
#   container_app_environment_id = azurerm_container_app_environment.main.id
#   revision_mode                = "Single"
#   workload_profile_name        = "consumption"

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.qdrant_app_identity.id]
#   }

#   registry {
#     server   = azurerm_container_registry.acr.login_server
#     identity = azurerm_user_assigned_identity.qdrant_app_identity.id
#   }

#   template {
#     min_replicas = 1
#     max_replicas = 5

#     container {
#       name   = "qdrant"
#       image  = "${azurerm_container_registry.acr.login_server}/qdrant:latest"
#       cpu    = 0.5
#       memory = "0.5Gi"

#       env {
#         name  = "RUN_MODE"
#         value = "dev"
#       }
#     }
#   }

#   ingress {
#     target_port      = 6333
#     external_enabled = false

#     traffic_weight {
#       percentage      = 100
#       latest_revision = true
#     }
#   }
# }

resource "azurerm_user_assigned_identity" "qdrant_app_identity" {
  resource_group_name = azurerm_resource_group.runtime_rg.name
  location            = azurerm_resource_group.runtime_rg.location
  name                = "qdrant-${var.environment}-uai"
}

resource "azurerm_role_assignment" "qdrant_app_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.qdrant_app_identity.principal_id
}

