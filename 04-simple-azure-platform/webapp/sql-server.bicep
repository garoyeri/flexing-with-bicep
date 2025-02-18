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
    elasticPools: [
      {
        name: n.nameSqlElasticPool(location, spaceName, workload, 1)
        sku: {
          name: 'StandardPool'
          tier: 'Standard'
          capacity: 200
        }
        maxSizeBytes: 200 * Gb
        // https://learn.microsoft.com/en-us/azure/azure-sql/database/resource-limits-dtu-elastic-pools?view=azuresql-db#standard-elastic-pool-limits
        perDatabaseSettings: {
          maxCapacity: '100'
          minCapacity: '10'
        }
      }
    ]
    databases: map(databases, d => {
      name: d.name
      sku: {
        name: 'S2'
        capacity: 100
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
