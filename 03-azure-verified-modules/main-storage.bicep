targetScope = 'resourceGroup'

@description('Location for the storage account.')
param location string = resourceGroup().location

// creating a new storage account
module storageAccount 'br/public:avm/res/storage/storage-account:0.17.3' = {
  name: 'storageAccountDeployment'
  params: {
    // Required parameters
    name: 'awesomestorage001'
    // Non-required parameters
    allowBlobPublicAccess: false
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
}

@description('Storage Account resource identifier.')
output storageId string = storageAccount.outputs.resourceId
