param location string
param storageAccountName string
param accountType string
param kind string
param minimumTlsVersion string
param supportsHttpsTrafficOnly bool
param allowBlobPublicAccess bool
param allowSharedKeyAccess bool
param defaultOAuth bool
param accessTier string
param publicNetworkAccess string
param allowCrossTenantReplication bool
param networkAclsBypass string
param networkAclsDefaultAction string
param networkAclsIpRules array
param dnsEndpointType string
param largeFileSharesState string
param keySource string
param encryptionEnabled bool
param keyTypeForTableAndQueueEncryption string
param infrastructureEncryptionEnabled bool
param isBlobSoftDeleteEnabled bool
param blobSoftDeleteRetentionDays int
param isContainerSoftDeleteEnabled bool
param containerSoftDeleteRetentionDays int
param isShareSoftDeleteEnabled bool
param shareSoftDeleteRetentionDays int

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  properties: {
    minimumTlsVersion: minimumTlsVersion
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultOAuth
    accessTier: accessTier
    publicNetworkAccess: publicNetworkAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    networkAcls: {
      bypass: networkAclsBypass
      defaultAction: networkAclsDefaultAction
      ipRules: networkAclsIpRules
    }
    dnsEndpointType: dnsEndpointType
    largeFileSharesState: largeFileSharesState
    encryption: {
      keySource: keySource
      services: {
        blob: {
          enabled: encryptionEnabled
        }
        file: {
          enabled: encryptionEnabled
        }
        table: {
          enabled: encryptionEnabled
        }
        queue: {
          enabled: encryptionEnabled
        }
      }
      requireInfrastructureEncryption: infrastructureEncryptionEnabled
    }
  }
  sku: {
    name: accountType
  }
  kind: kind
  tags: {}
  dependsOn: []
}

resource storageAccountName_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      enabled: isBlobSoftDeleteEnabled
      days: blobSoftDeleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: isContainerSoftDeleteEnabled
      days: containerSoftDeleteRetentionDays
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileservices_storageAccountName_default 'Microsoft.Storage/storageAccounts/fileservices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    protocolSettings: null
    shareDeleteRetentionPolicy: {
      enabled: isShareSoftDeleteEnabled
      days: shareSoftDeleteRetentionDays
    }
  }
  dependsOn: [
    storageAccountName_default
  ]
}
