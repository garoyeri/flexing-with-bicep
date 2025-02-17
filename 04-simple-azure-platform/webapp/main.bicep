targetScope = 'resourceGroup'

import * as n from '../names.bicep'

@description('Location for all resources.')
param location string = resourceGroup().location

param spaceName string

param workload string

param index n.Index = 1


