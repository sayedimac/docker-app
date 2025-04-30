param containerInstanceName string
param location string = resourceGroup().location
param acrName string
param imageName string
param containerPort int = 80
param cpuCores string = '1.0'
param memoryInGb string = '1.5'
param restartPolicy string = 'Always'

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' existing = {
  name: acrName
}

// Get the ACR admin credentials
resource acrCredentials 'Microsoft.ContainerRegistry/registries/listCredentials@2021-06-01-preview' = {
  parent: acr
  name: 'default'
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-10-01' = {
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
        username: acrCredentials.username
        password: acrCredentials.passwords[0].value
      }
    ]
  }
}

output containerIPv4Address string = containerGroup.properties.ipAddress.ip
output fqdn string = containerGroup.properties.ipAddress.fqdn
