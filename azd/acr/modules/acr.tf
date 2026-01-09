# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.registry_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
}

output "acr_id" {
  value       = azurerm_container_registry.acr.id
  description = "Container registry ID"
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "Container registry name"
}

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "Container registry login server"
}

variable "registry_name" {
  type        = string
  description = "Name of the container registry"
}

variable "location" {
  type        = string
  description = "Azure region location"
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
  default     = null
}

variable "sku" {
  type        = string
  description = "SKU for the container registry"
  default     = "Basic"
}

variable "admin_enabled" {
  type        = bool
  description = "Enable admin user for the registry"
  default     = true
}
