terraform {
  required_version = "~> 1.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.4.0"
    }

    azuread = {
      source = "hashicorp/azuread"
      version = "~> 2.53.1"
    }
  }

  backend "azurerm" {
    use_azuread_auth = true
  }
}
