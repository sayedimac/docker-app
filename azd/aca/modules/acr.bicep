// ACR (Azure Container Registry) Bicep Template
param registryName string
param location string = resourceGroup().location
param sku string = 'Basic'
param addAdminUser bool = true

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: registryName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: addAdminUser
  }
}

// Outputs for linking to AKS and other services
output acrId string = acr.id
output acrName string = acr.name
output acrLoginServer string = acr.properties.loginServer
// Alias outputs used by ACI/ACA modules
output name string = acr.name
output loginServer string = acr.properties.loginServer
output adminUsername string = acr.listCredentials().username
output adminPassword string = acr.listCredentials().passwords[0].value
