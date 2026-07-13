targetScope = 'subscription'

param Location string
param VnetName string

param VnetIpRange string
param subnetIpRange string

param subnet1Name string

param workernode1name string
param workernode2name string
param workernode3name string
param controlnodename string

param nsgname string

resource k8sRG 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'k8s-learn'
  location: Location
}
module k8svnet 'br/public:avm/res/network/virtual-network:0.9.0' = {
  scope: k8sRG
  params: {
    name: VnetName
    addressPrefixes: [
      VnetIpRange
    ]
    location: Location
    subnets: [
      {
        name: subnet1Name
        addressPrefix: subnetIpRange
      }
    ]
  }
}

module node1 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  scope: k8sRG
  dependsOn: [
    controlnode
  ]
  params: {
    name: workernode1name
    computerName: workernode1name
    availabilityZone: 1
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        name: workernode1name
        nicSuffix: '-nic'
        networkSecurityGroupResourceId:nsg.outputs.resourceId
        ipConfigurations: [
          {
            subnetResourceId: k8svnet.outputs.subnetResourceIds[0]
          }
        ]
      }
    ]
    location: Location
    hibernationEnabled: false
    managedIdentities: {
      systemAssigned: true
    }
    timeZone: 'W. Europe Standard Time'
    disablePasswordAuthentication: false
    allowExtensionOperations: true
    imageReference: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'ubuntu-pro'
      version: 'latest'
    }
    osDisk: {
      name: '${workernode1name}-OsDisk'
      createOption: 'FromImage'
      caching: 'ReadWrite'
      diskSizeGB: 30
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
      deleteOption: 'Delete'
    }
    osType: 'Linux'
    autoShutdownConfig: {
      dailyRecurrenceTime: '1900'
      timeZone: 'W. Europe Standard Time'
      status: 'Enabled'
    }
    vmSize: 'Standard_B2ms'
    adminUsername: 'azureuser'
    patchMode: 'ImageDefault'
    provisionVMAgent:true
  }
}

module node2 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  scope: k8sRG
  dependsOn: [
    controlnode
  ]
  params: {
    name: workernode2name
    computerName: workernode2name
    availabilityZone: 1
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        name: workernode2name
        nicSuffix: '-nic'
        networkSecurityGroupResourceId:nsg.outputs.resourceId
        ipConfigurations: [
          {
            subnetResourceId: k8svnet.outputs.subnetResourceIds[0]
          }
        ]
      }
    ]
    location: Location
    hibernationEnabled: false
    managedIdentities: {
      systemAssigned: true
    }
    timeZone: 'W. Europe Standard Time'
    disablePasswordAuthentication: false
    allowExtensionOperations: true
    imageReference: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'ubuntu-pro'
      version: 'latest'
    }
    osDisk: {
      name: '${workernode2name}-OsDisk'
      createOption: 'FromImage'
      caching: 'ReadWrite'
      diskSizeGB: 30
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
      deleteOption: 'Delete'
    }
    osType: 'Linux'
    autoShutdownConfig: {
      dailyRecurrenceTime: '1900'
      timeZone: 'W. Europe Standard Time'
      status: 'Enabled'
    }
    vmSize: 'Standard_B2ms'
    adminUsername: 'azureuser'
    patchMode: 'ImageDefault'
    provisionVMAgent:true
  }
}

module node3 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  dependsOn: [
    controlnode
  ]
  scope: k8sRG
  params: {
    name: workernode3name
    computerName: workernode3name
    availabilityZone: 1
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        name: workernode3name
        nicSuffix: '-nic'
        networkSecurityGroupResourceId:nsg.outputs.resourceId
        ipConfigurations: [
          {
            subnetResourceId: k8svnet.outputs.subnetResourceIds[0]
          }
        ]
      }
    ]
    location: Location
    hibernationEnabled: false
    managedIdentities: {
      systemAssigned: true
    }
    timeZone: 'W. Europe Standard Time'
    disablePasswordAuthentication: false
    allowExtensionOperations: true
    imageReference: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'ubuntu-pro'
      version: 'latest'
    }
    osDisk: {
      name: '${workernode3name}-OsDisk'
      createOption: 'FromImage'
      caching: 'ReadWrite'
      diskSizeGB: 30
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
      deleteOption: 'Delete'
    }
    osType: 'Linux'
    autoShutdownConfig: {
      dailyRecurrenceTime: '1900'
      timeZone: 'W. Europe Standard Time'
      status: 'Enabled'
    }
    vmSize: 'Standard_B2ms'
    adminUsername: 'azureuser'
    patchMode: 'ImageDefault'
    provisionVMAgent:true
  }
}

module controlnode 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  scope: k8sRG
  params: {
    name: controlnodename
    computerName: controlnodename
    availabilityZone: 1
    nicConfigurations: [
      {
        deleteOption: 'Delete'
        name: controlnodename
        nicSuffix: '-nic'
        networkSecurityGroupResourceId:nsg.outputs.resourceId
        ipConfigurations: [
          {
            subnetResourceId: k8svnet.outputs.subnetResourceIds[0]
            pipConfiguration: {
              name: '${controlnodename}-pip'
              location:Location
              availabilityZones: [
                1
              ]
            }
          }
        ]
      }
    ]
    location: Location
    hibernationEnabled: false
    managedIdentities: {
      systemAssigned: true
    }
    timeZone: 'W. Europe Standard Time'
    disablePasswordAuthentication: false
    allowExtensionOperations: true
    imageReference: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'ubuntu-pro'
      version: 'latest'
    }
    osDisk: {
      name: '${controlnodename}-OsDisk'
      createOption: 'FromImage'
      caching: 'ReadWrite'
      diskSizeGB: 30
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
      deleteOption: 'Delete'
    }
    osType: 'Linux'
    autoShutdownConfig: {
      dailyRecurrenceTime: '1900'
      timeZone: 'W. Europe Standard Time'
      status: 'Enabled'
    }
    vmSize: 'Standard_B2ms'
    adminUsername: 'azureuser'
    patchMode: 'ImageDefault'
    provisionVMAgent:true
  }
}

module nsg 'br/public:avm/res/network/network-security-group:0.5.3' = {
  scope: k8sRG
  params: {
    name: nsgname
    location:Location
    securityRules:[
      {
        name: 'allow-ssh'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 200
          protocol: 'Tcp'
          description: 'Allow ssh inbound'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
        }
      }
    ]
  }
}
