terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Generate a unique resource token
resource "random_string" "resource_token" {
  length  = 13
  special = false
  upper   = false
  numeric = true
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment_name}"
  location = var.location

  tags = {
    "azd-env-name" = var.environment_name
  }
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acr${random_string.resource_token.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Basic"
  admin_enabled       = true
}

# AKS Cluster
# Note: RBAC is disabled to match the Bicep configuration, but enabling RBAC is recommended for production
resource "azurerm_kubernetes_cluster" "aks" {
  name                              = "aks-${random_string.resource_token.result}"
  location                          = azurerm_resource_group.main.location
  resource_group_name               = azurerm_resource_group.main.name
  dns_prefix                        = "aks-${random_string.resource_token.result}"
  role_based_access_control_enabled = false

  default_node_pool {
    name            = "agentpool"
    node_count      = var.agent_count
    vm_size         = var.agent_vm_size
    os_disk_size_gb = var.os_disk_size_gb
    os_sku          = var.os_type == "Linux" ? "Ubuntu" : "Windows2022"
    type            = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    displayname = "AKS Cluster"
  }
}

# Role assignment for ACR pull
resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
