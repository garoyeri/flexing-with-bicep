targetScope = 'resourceGroup'

import * as n from '../names.bicep'

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string

param workload string

param index n.Index = 1

@description('Log Analytics Workspace to use for diagnostics.')
param logAnalyticsWorkspaceId string

param serverFarmResourceId string

param vnetSubnetId string

module app 'br/public:avm/res/web/site:0.13.3' = {
  name: 'app'
  params: {
    name: n.nameWebApplication(location, spaceName, workload, index)
    kind: 'app'
    location: location
    serverFarmResourceId: serverFarmResourceId
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceId
      }
    ]
    virtualNetworkSubnetId: vnetSubnetId
  }
}

output appId string = app.outputs.resourceId
