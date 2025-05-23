// ACR (Azure Container Registry) Bicep Template
param registryName string
param location string = resourceGroup().location
param sku string = 'Basic'
param addAdminUser bool = true

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: registryName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: addAdminUser
  }
}

// Outputs for linking to AKS
output acrId string = acr.id
output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
