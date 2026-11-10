targetScope = 'subscription'

param RGName string
param Location string
param StorageAccountName string
param Sharename string

resource ExistingK8slearnRg 'Microsoft.Resources/resourceGroups@2025-04-01' existing = {
  name: 'k8slearn'
}

resource ExistingVnet 'Microsoft.ScVmm/virtualNetworks@2025-03-13' existing = {
  name: 'k8s-test'
  scope: ExistingK8slearnRg
}

resource StorageResourcegroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: RGName
  location: Location
}

module storaccount 'br/public:avm/res/storage/storage-account:0.33.1' = {
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
        id: 'vExistingVnet.id/subnets/subnet1'
        action: 'Allow'
        }
      ]
    }
    roleAssignments:[
      {
        principalId: 'ccccccc'
        roleDefinitionIdOrName: 'Storage File Data SMB Share Reader'
      }
    ]
  }
}
