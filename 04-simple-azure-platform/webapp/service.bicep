targetScope = 'resourceGroup'

import * as n from '../names.bicep'

type AppServicePlanSize = 'XS' | 'S' | 'M' | 'L'

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string

param workload string

param index n.Index = 1

param size AppServicePlanSize = 'S'

@description('Log Analytics Workspace to use for diagnostics.')
param logAnalyticsWorkspaceId string

var skuMap = {
  XS: 'B1'
  S: 'B2'
  M: 'P1V3'
  L: 'P3V3'
}

module asp 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'asp'
  params: {
    name: n.nameWebServerFarm(location, spaceName, workload, index)
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspaceId
      }
    ]
    skuName: skuMap[size]
  }
}

output servicePlanId string = asp.outputs.resourceId
