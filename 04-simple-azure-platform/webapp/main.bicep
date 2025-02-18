targetScope = 'resourceGroup'

import * as n from '../names.bicep'
import { AppServicePlanSize } from 'service.bicep'
import { DatabaseSpecification } from 'sql-server.bicep'

@description('Location for all resources.')
param location string = resourceGroup().location

param specification ApplicationSpecification

// calculate the names of things
var networkName = n.nameNetworkVnet(location, specification.spaceName, 1)
// var networkId = resourceId('Microsoft.Network/virtualNetworks@2024-01-01', networkName)
var subnetRoles = [
  'PrivateLink'
  'VM'
  'App'
  'PGSQL'
  'AGW'
]
var subnets = toObject(
  map(subnetRoles, s => {
    role: s
    name: n.nameNetworkSubnet(location, s, 1)
    id: resourceId(
      'Microsoft.Network/virtualNetworks/subnets@2024-01-01',
      networkName,
      n.nameNetworkSubnet(location, s, 1)
    )
  }),
  o => o.role,
  o => { name: o.name, id: o.id }
)

resource log 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: n.nameLogWorkspace(location, specification.spaceName, 1)
}

module asp 'service.bicep' = {
  name: '${deployment().name}-ASP'
  params: {
    logAnalyticsWorkspaceId: log.id
    spaceName: specification.spaceName
    workload: specification.workload
    size: specification.?size ?? 'S'
  }
}

module app 'app.bicep' = {
  name: '${deployment().name}-APP'
  params: {
    logAnalyticsWorkspaceId: log.id
    serverFarmResourceId: asp.outputs.servicePlanId
    spaceName: specification.spaceName
    vnetSubnetId: subnets.App.id
    workload: specification.workload
  }
}

module sqlep 'sql-server.bicep' = if (specification.useSql) {
  name: '${deployment().name}-SQL'
  params: {
    spaceName: specification.spaceName
    logAnalyticsWorkspaceId: log.id
    vnetSubnetId: subnets.PrivateLink.id
    workload: specification.workload
    databases: specification.databases
  }
}


type ApplicationSpecification = {
  spaceName: string
  workload: string

  size: AppServicePlanSize?

  useSql: bool
  databases: DatabaseSpecification[]
}


