variable "subscription_id" {
  type        = string
  description = "The subscription id hosting the solution"
}

variable "dns_subscription_id" {
  type        = string
  description = "The subscription id hosting the private dns zones"
}

variable "environment" {
  type        = string
  description = "The environment name for the solution"
  default     = "dev"

  validation {
    condition     = contains(["dev", "acc", "prd"], var.api_environment_name)
    error_message = "The name must be either 'dev', 'acc' or 'prd'."
  }
}

variable "vnet_id" {
  description = "(Required) vnet id of the vnet where the solution will be deployed in"
}

variable "data_subnet_id" {
  description = "(Required) The subnet id of the subnet containing all the data components"
}

variable "runtime_subnet_id" {
  description = "(Required) The subnet id of the subnet containing the Azure container App Environment"
}