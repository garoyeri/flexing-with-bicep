targetScope = 'resourceGroup'

import * as n from '../names.bicep'

@export()
type DatabaseSpecification = {
  name: string
}

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string

param workload string

param index n.Index = 1

param vnetSubnetId string
param logAnalyticsWorkspaceId string

param databases DatabaseSpecification[] = []

var Gb = 1024 * 1024 * 1024

module sqlep 'br/public:avm/res/sql/server:0.12.3' = {
  name: 'sqlep'
  params: {
    name: n.nameSqlServer(location, spaceName, workload, index)
    location: location
    // normally you would NOT do this, instead designate an Entra ID group
    administratorLogin: 'nimda'
    // if you are using non Entra ID admins, then use Key Vault to do this instead (TODO)
    administratorLoginPassword: '8JjJnFwxfJYpQ^8uSBQ7'
    privateEndpoints: [
      {
        subnetResourceId: vnetSubnetId
      }
    ]
    databases: map(databases, d => {
      name: d.name
      sku: {
        name: 'S1'
        capacity: 20
      }
      maxSizeBytes: 100 * Gb
      diagnosticSettings: [
        {
          workspaceResourceId: logAnalyticsWorkspaceId
        }
      ]
      zoneRedundant: false
    })
  }
}
