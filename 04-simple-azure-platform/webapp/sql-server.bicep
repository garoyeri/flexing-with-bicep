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
          name: 'StandardPool'
          tier: 'Standard'
          capacity: 200
        }
      }
    ]
    databases: map(databases, d => {
      name: d.name
      sku: {
        name: 'S2'
      }
      elasticPoolResourceId: resourceId(
        'Microsoft.Sql/servers/elasticPools@2023-08-01-preview',
        n.nameSqlServer(location, spaceName, workload, index),
        n.nameSqlElasticPool(location, spaceName, workload, 1)
      )
      diagnosticSettings: [
        {
          workspaceResourceId: logAnalyticsWorkspaceId
        }
      ]
    })
  }
}
