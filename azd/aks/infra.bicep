targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Name of the AKS cluster')
param aksClusterName string = 'aks-${environmentName}'

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }
var registryName = 'acr${resourceToken}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module containerRegistry '../acr/modules/acr.bicep' = {
  name: 'registry'
  scope: resourceGroup
  params: {
    location: location
    registryName: registryName
    sku: 'Basic'
    addAdminUser: true
  }
}

module aksCluster 'modules/aks.bicep' = {
  name: 'aks-cluster'
  scope: resourceGroup
  params: {
    location: location
    aksClusterName: aksClusterName
    acrResourceId: containerRegistry.outputs.acrId
  }
}

output AZURE_LOCATION string = location
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.acrLoginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.outputs.acrName
output AKS_CONTROL_PLANE_FQDN string = aksCluster.outputs.controlPlaneFQDN
