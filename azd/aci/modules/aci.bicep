param containerInstanceName string
param location string = resourceGroup().location
param acrName string
param imageName string
param containerPort int = 8080
param cpuCores string = '1.0'
param memoryInGb string = '1.5'
param restartPolicy string = 'Always'

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2023-05-01' = {
  name: containerInstanceName
  location: location
  properties: {
    containers: [
      {
        name: containerInstanceName
        properties: {
          image: '${acr.properties.loginServer}/${imageName}:latest'
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
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
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
        server: acr.properties.loginServer
        username: acr.listCredentials().username
        password: acr.listCredentials().passwords[0].value
      }
    ]
  }
}

output containerIPv4Address string = containerGroup.properties.ipAddress.ip
output uri string = 'http://${containerGroup.properties.ipAddress.ip}:${containerPort}'
