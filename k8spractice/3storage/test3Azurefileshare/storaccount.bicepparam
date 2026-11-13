using './storaccount.bicep'

param RGName = 'k8slearnstorage'
param Location = 'northeurope'
param StorageAccountName = 'k8slearnjbo'
param Sharename = 'test1'
param subnet1Name = 'subnet1'
param PublicIPLearner = ''
param PublicIpOffice = '131.224.251.77'
