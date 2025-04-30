targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('The container image to deploy')
param containerImage string = ''

@description('Port the container listens on')
param containerPort int = 80

@description('CPU cores allocated to the container instance')
param cpuCores string = '1.0'

@description('Memory allocated to the container instance in GB')
param memoryInGb string = '1.5'

var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

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
    registryName: 'acr${resourceToken}'
    sku: 'Basic'
    addAdminUser: true
  }
}

module containerInstance './modules/container-instance.bicep' = {
  name: 'container-instance'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    name: 'aci-${resourceToken}'
    containerImage: !empty(containerImage) ? containerImage : 'mcr.microsoft.com/azuredocs/aci-helloworld'
    containerPort: containerPort
    cpuCores: cpuCores
    memoryInGb: memoryInGb
    registryLoginServer: containerRegistry.outputs.loginServer
    registryUsername: containerRegistry.outputs.adminUsername
    registryPassword: containerRegistry.outputs.adminPassword
  }
}

output AZURE_LOCATION string = location
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.loginServer
output AZURE_CONTAINER_REGISTRY_NAME string = containerRegistry.outputs.name
output ACI_URI string = containerInstance.outputs.uri
