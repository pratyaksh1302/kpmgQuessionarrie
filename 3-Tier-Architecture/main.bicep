param dbTier object
param NSGGroups array
param nsgrules array

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
