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

output "AKS_CLUSTER_NAME" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS cluster name"
}

output "AKS_CLUSTER_FQDN" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "AKS cluster FQDN"
}

output "AKS_IDENTITY_PRINCIPAL_ID" {
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  description = "AKS identity principal ID"
}
