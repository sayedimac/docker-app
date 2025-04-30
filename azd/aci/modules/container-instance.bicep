param name string
param location string = resourceGroup().location
param tags object = {}

param containerImage string
param containerPort int
param cpuCores string
param memoryInGb string
param registryLoginServer string
param registryUsername string
@secure()
param registryPassword string
param environmentVariables array = []

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    containers: [
      {
        name: name
        properties: {
          image: containerImage
          ports: [
            {
              port: containerPort
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          environmentVariables: environmentVariables
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: 'Always'
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: containerPort
          protocol: 'TCP'
        }
      ]
    }
    imageRegistryCredentials: [
      {
        server: registryLoginServer
        username: registryUsername
        password: registryPassword
      }
    ]
  }
}

output id string = containerGroup.id
output name string = containerGroup.name
output ipAddress string = containerGroup.properties.ipAddress.ip
output uri string = 'http://${containerGroup.properties.ipAddress.ip}:${containerPort}'
