targetScope = 'subscription'

param RGName string
param Location string
param StorageAccountName string
param Sharename string
param subnet1Name string


var currentUserId = deployer().objectId

resource ExistingK8slearnRg 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: 'k8slearn'
}

resource ExistingVnet 'Microsoft.Network/virtualNetworks@2026-03-01' existing = {
  name: 'k8s-test'
  scope: ExistingK8slearnRg
}

resource existingSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  parent: ExistingVnet
  name: subnet1Name
}

resource StorageResourcegroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: RGName
  location: Location
}

module Storaccount 'br/public:avm/res/storage/storage-account:0.33.1' = {
  scope: StorageResourcegroup
  params: {
    name: StorageAccountName
    kind:'StorageV2'
    accessTier:'Cool'
    fileServices:{
      shares:[
        {
          name: Sharename
        }
      ]
    }
    publicNetworkAccess:'Enabled'
    networkAcls:{
      virtualNetworkRules:[
        {
        id: existingSubnet.id
        action: 'Allow'
        }
      ]
    }
    roleAssignments:[
      {
        principalId: currentUserId
        roleDefinitionIdOrName: 'Storage File Data SMB Share Reader'
      }
    ]
  }
}
