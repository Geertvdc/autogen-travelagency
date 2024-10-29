provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  subscription_id = var.subscription_id
}

provider "azurerm" {
  features {}
  alias                           = "private-dns-subscription"
  subscription_id                 = var.dns_subscription_id
  resource_provider_registrations = "none"
}