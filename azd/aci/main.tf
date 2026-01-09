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

# Container Instance
resource "azurerm_container_group" "main" {
  name                = "aci-${random_string.resource_token.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = "Always"

  tags = {
    "azd-env-name" = var.environment_name
  }

  container {
    name   = "aci-${random_string.resource_token.result}"
    image  = var.container_image != "" ? var.container_image : "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = var.container_port
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
}
