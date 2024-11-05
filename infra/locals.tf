locals {
  project_name = "ai-review-bot"
  location = "westeurope"
  runtime_resource_group_name = "${local.project_name}-runtime-${var.environment}-rg"
  data_resource_group_name = "${local.project_name}-data-${var.environment}-rg"
  containerapp_env_name = "${local.project_name}-${var.environment}-cae"
}