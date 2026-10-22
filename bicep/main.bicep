targetScope = 'subscription'

param RGName string

param Location string
param VnetName string

param VnetIpRange string
param subnetIpRange string

param subnet1Name string

param workernode1name string
param workernode2name string
param workernode3name string
param controlnodename string

@secure()
param vmadminpassword string

param nsgname string

param PublicIPLearner string

resource k8sRG 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: RGName
  location: Location
}
module k8svnet 'br/public:avm/res/network/virtual-network:0.9.0' = {
  name:'k8svnet'
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
        networkSecurityGroupResourceId:nsg.outputs.resourceId
      }
    ]
  }
}

module node1 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  name:'node1'
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
        enableAcceleratedNetworking: false
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
    adminPassword:vmadminpassword
  }
}

module node2 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  name:'node2'
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
        enableAcceleratedNetworking: false
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
    adminPassword:vmadminpassword
  }
}

module node3 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  name:'node3'
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
        enableAcceleratedNetworking: false
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
    adminPassword:vmadminpassword
  }
}

module controlnode 'br/public:avm/res/compute/virtual-machine:0.22.2' = {
  name:'controlnode'
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
        enableAcceleratedNetworking: false
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
    adminPassword:vmadminpassword
  }
}

module nsg 'br/public:avm/res/network/network-security-group:0.5.3' = {
  name:'nsg'
  scope: k8sRG
  params: {
    name: nsgname
    location:Location
    securityRules:[
      {
        name: 'allow-ssh-all'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 200
          protocol: 'Tcp'
          description: 'Allow ssh inbound'
          destinationPortRange: '22'
          sourcePortRange:'*'
          destinationAddressPrefix:subnetIpRange
          sourceAddressPrefixes:[
            subnetIpRange
            PublicIPLearner
          ]
        }
      }
      {
        name: 'allow-k8s-api'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 201
          protocol: 'Tcp'
          destinationPortRange: '6443'
          sourcePortRange:'*'
          destinationAddressPrefix:subnetIpRange
          sourceAddressPrefixes:[
            subnetIpRange
            PublicIPLearner
          ]
        }
      }
      {
        name: 'allow-node-ports'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 202
          protocol: 'Tcp'
          sourcePortRange:'*'
          destinationAddressPrefix:subnetIpRange
          destinationPortRanges:[
            '30000-32767'
          ]
          sourceAddressPrefixes:[
            subnetIpRange
            PublicIPLearner
          ]
        }
      }
      {
        name: 'nodemanagement'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 203
          protocol: 'Tcp'
          sourcePortRange:'*'
          destinationPortRange: '10250'
          sourceAddressPrefix:subnetIpRange
          destinationAddressPrefix:subnetIpRange
        }
      }
      {
        name: 'allow-ping'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 204
          protocol: 'Icmp'
          sourcePortRange:'*'
          destinationPortRange: '*'
          destinationAddressPrefix:subnetIpRange
          sourceAddressPrefix:subnetIpRange
        }
      }
      {
        name: 'allow-whisker-calico'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 205
          protocol: 'Icmp'
          sourcePortRange:'*'
          destinationPortRange: '8443'
          destinationAddressPrefix:subnetIpRange
          sourceAddressPrefix:PublicIPLearner
        }
      }
      {
        name: 'deny-all'
        properties: {
          access: 'Deny'
          direction: 'Inbound'
          priority: 1000
          protocol: 'Tcp'
          sourceAddressPrefix:'*'
          destinationAddressPrefix:'*'
          sourcePortRange:'*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

module privdnszone 'br/public:avm/res/network/private-dns-zone:0.8.1' = {
  name:'privdnszone'
  scope: k8sRG
  params: {
    name: 'k8slearn.test'
    location:'global'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: k8svnet.outputs.resourceId
        registrationEnabled:true
      }
    ]
  }
}
