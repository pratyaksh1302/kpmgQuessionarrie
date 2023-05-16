param dbTier object
param NSGGroups array
param nsgrules array
param vnets object
param pipObj object
param nicNames array

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

module pipCreate 'modules/pip.bicep' = {
  name: 'deployment4'
  scope: resourceGroup()
  params: {
    pipObj: pipObj
  }
  dependsOn: [
    dblayer
    vnetCreate
    nsgCreate
  ]
}

module nicCreate 'modules/nic.bicep' = {
  name: 'deployment5'
  scope: resourceGroup()
  params: {
    nicNames: nicNames
  }
}
