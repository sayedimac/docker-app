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

# Container Apps Environment
resource "azurerm_container_app_environment" "env" {
  name                = "cae-${random_string.resource_token.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Container App
resource "azurerm_container_app" "app" {
  name                         = "ca-${random_string.resource_token.result}"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.acr.admin_password
  }

  template {
    container {
      name   = "ca-${random_string.resource_token.result}"
      image  = var.container_image != "" ? "${azurerm_container_registry.acr.login_server}/${var.container_image}:latest" : "${azurerm_container_registry.acr.login_server}/docker-app:latest"
      cpu    = var.cpu_cores
      memory = var.memory_in_gb
    }

    min_replicas = 1
    max_replicas = 3

    http_scale_rule {
      name                = "http-scale-rule"
      concurrent_requests = "10"
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.container_port
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}
