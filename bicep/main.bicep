targetScope='resourceGroup'

param VnetName string

module k8svnet 'br/public:avm/res/network/virtual-network:0.9.0' = {
  params: {
    name: 
    addressPrefixes: 
  }
}
