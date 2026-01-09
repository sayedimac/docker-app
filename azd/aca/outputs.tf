output "AZURE_LOCATION" {
  value       = var.location
  description = "Azure location where resources are deployed"
}

output "AZURE_CONTAINER_REGISTRY_ENDPOINT" {
  value       = azurerm_container_registry.acr.login_server
  description = "Container registry login server"
}

output "AZURE_CONTAINER_REGISTRY_NAME" {
  value       = azurerm_container_registry.acr.name
  description = "Container registry name"
}

output "CONTAINER_APP_URL" {
  value       = "https://${azurerm_container_app.app.latest_revision_fqdn}"
  description = "Container App URL"
}
