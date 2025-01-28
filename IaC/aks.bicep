@description('The name of the Managed Cluster resource.')
param aksClusterName string

@description('The location of AKS resource.')
param location string = resourceGroup().location

@allowed([
  'new'
  'existing'
])
param newOrExisting string = 'new'

@description('Disk size (in GiB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production')
@minValue(1)
@maxValue(100)
param agentCount int = 3

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_D2s_v3'

@description('The type of operating system.')
@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-02-01' = if (newOrExisting == 'new') {
  location: location
  name: aksClusterName
  tags: {
    displayname: 'AKS Cluster'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableRBAC: false
    dnsPrefix: "jaz400"
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: osType
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
  }
}
resource saExisting 'Microsoft.ContainerService/managedClusters@2024-02-01' existing = if (newOrExisting == 'existing') {
  name: aksClusterName
}

output controlPlaneFQDN string = aksCluster.properties.fqdn
