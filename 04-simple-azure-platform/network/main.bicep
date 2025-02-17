targetScope = 'resourceGroup'

import * as n from '../names.bicep'

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string = 'dev'

module log 'br/public:avm/res/operational-insights/workspace:0.11.0' = {
  name: 'log'
  params: {
    name: n.nameLogWorkspace(location, spaceName, 1)
    location: location
  }
}

/*
  Create a virtual network with all the usual subnets we need:
  - PrivateLink
  - Virtual Machines
  - App Services
  - PostgreSQL
  - Application Gateway
*/
module vnet 'br/public:avm/res/network/virtual-network:0.5.2' = {
  name: 'vnet'
  params: {
    name: n.nameNetworkVnet(location, spaceName, 1)
    addressPrefixes: [
      '10.0.0.0/24'
    ]
    subnets: [
      // Note: use a tool to help you plan out the subnets:
      // For example: https://visualsubnetcalc.com/
      // Get a list of delegations using:
      // `az network vnet subnet list-available-delegations --location eastus`

      // Private Links
      {
        name: n.nameNetworkSubnet(location, 'PrivateLink', 1)
        addressPrefixes: [
          '10.0.0.0/26'
        ]
      }

      // Virtual Machines
      {
        name: n.nameNetworkSubnet(location, 'VM', 1)
        addressPrefixes: [
          '10.0.0.64/27'
        ]
      }

      // App Services: delegated
      {
        name: n.nameNetworkSubnet(location, 'App', 1)
        addressPrefixes: [
          '10.0.0.96/27'
        ]
        delegation: n.networkDelegations.Microsoft_Web_serverFarms
      }

      // PostgreSQL Flexible Servers: delegated
      {
        name: n.nameNetworkSubnet(location, 'PGSQL', 1)
        addressPrefixes: [
          '10.0.0.128/27'
        ]
        delegation: n.networkDelegations.Microsoft_DBforPostgreSQL_flexibleServers
      }

      // Application Gateway
      {
        name: n.nameNetworkSubnet(location, 'AGW', 1)
        addressPrefixes: [
          '10.0.0.160/27'
        ]
        // doesn't use explicit delegation, but once you deploy to it, it will reserve
      }

      // 10.0.0.192/26	is available as slack
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: log.outputs.logAnalyticsWorkspaceId
      }
    ]
  }
}

output logAnalyticsWorkspaceId string = log.outputs.logAnalyticsWorkspaceId
output networkId string = vnet.outputs.resourceId
