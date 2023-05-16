param dbTier object
param NSGGroups array
param nsgrules array
param vnets object

module dblayer 'modules/sqlsvr.bicep' = {
  name: 'deployment1'
  scope: resourceGroup()
  params: {
    dbTier: dbTier
  }
}

module nsgCreate 'modules/vmnsg.bicep' = {
  name: 'deployment2'
  scope: resourceGroup()
  params: {
    NSGGroups: NSGGroups
    nsgrules: nsgrules
  }
  dependsOn: [
    dblayer
  ]
}

module vnetCreate 'modules/vnet.bicep' = {
  name: 'deployment3'
  scope: resourceGroup()
  params: {
    vnets: vnets
  }
  dependsOn: [
    dblayer
  ]
}
