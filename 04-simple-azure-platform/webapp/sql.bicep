targetScope = 'resourceGroup'

import * as n from '../names.bicep'

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string

param workload string

param index n.Index = 1

param vnetSubnetId string

module sqlep 'br/public:avm/res/sql/server:0.12.3' = {
  name: 'sqlep'
  params: {
    name: n.nameSqlServer(location, spaceName, workload, index)
    location: location
    privateEndpoints: [
      {
        subnetResourceId: vnetSubnetId
      }
    ]
    elasticPools: [
      {
        name: n.nameSqlElasticPool(location, spaceName, workload, 1)
        sku: {
          name: 'GP_Gen5'
          tier: 'GeneralPurpose'
          capacity: 4
        }
      }
    ]
  }
}
