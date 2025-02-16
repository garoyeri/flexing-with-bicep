targetScope = 'resourceGroup'

import * as n from '../names.bicep'

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string = 'dev'

/*
  Create a virtual network with all the usual subnets we need:

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
        delegation: 
      }

      // PostgreSQL: delegated
      {
        name: n.nameNetworkSubnet(location, 'PGSQL', 1)
        addressPrefixes: [
          '10.0.0.128/27'
        ]
      }
    ]
  }
}
