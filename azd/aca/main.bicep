targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('The container image name to deploy')
param imageName string = 'docker-app'

@description('Port the container listens on')
param containerPort int = 8080

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }
var containerAppName = 'aca-${resourceToken}'
var registryName = 'acr${resourceToken}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module containerRegistry './modules/acr.bicep' = {
  name: 'registry'
  scope: resourceGroup
  params: {
    location: location
    registryName: registryName
    sku: 'Basic'
    addAdminUser: true
  }
}

module containerApp './modules/aca.bicep' = {
  name: 'container-app'
  scope: resourceGroup
  params: {
    location: location
    containerAppName: containerAppName
    acrName: containerRegistry.outputs.name
    imageName: imageName
    containerPort: containerPort
  }
}

output AZURE_LOCATION string = location
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.outputs.name
output ACA_URL string = containerApp.outputs.containerAppUrl
