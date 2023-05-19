param location string = 'eastus'
param dbTier object = {
  sqlServerName: 'pratsqlserver'
  username: ''
  password: ''

}
param NSGGroups array = [
  {
    name: 'web-nsg'
    tags: {
      tier: 'presentation'
    }
  }
  {
    name: 'app-nsg'
    tags: {
      tier: 'application'
    }
  }
]
param pipObj object = {
  name: 'web-vm-nic-pip'
}
// param nsgrules array = [
//   {
//     properties: {
//       securityRules: [
//         {
//           name: 'http'
//           properties: {
//             protocol: 'Tcp'
//             sourcePortRange: '*'
//             destinationPortRange: '80'
//             sourceAddressPrefix: '*'
//             destinationAddressPrefix: '*'
//             access: 'Allow'
//             priority: 300
//             direction: 'Inbound'
//           }
//         }
//       ]
//     }
//   }
// ]
 param vnets object = {
  name: 'demo-vnet'
  addressPrefix: '10.124.190.0/24'
  webSubnetName: 'web-subnet'
  webSubnetPrefix: '10.124.190.0/27'
  appSubnetName: 'app-subnet'
  appSubnetPrefix: '10.124.190.32/27'
 }
param nicNames array = [
  {
    name: 'web-nic'
    tier: 'presentation'
    privateIPAddress: '10.124.190.4'
    publicIPAddress: {
      publicIpAddressName: 'web-vm-nic-pip'
    }
    vnetName: 'demo-vnet'
    subnetName: 'web-subnet'
    networkSecurityGroup: {
      nsgName: 'web-nsg'
    }
  }
  {
    name: 'app-nic'
    tier: 'application'
    privateIPAddress: '10.124.190.37'
    // publicIPAddress: {
    //   publicIpAddressName: 'web-vm-nic-pip'
    // }
    vnetName: 'demo-vnet'
    subnetName: 'app-subnet'
    networkSecurityGroup: {
      nsgName: 'app-nsg'
    }
  }
]

module dbCreate 'modules/sqlsvr.bicep' = {
  name: 'deployment1'
  scope: resourceGroup()
  params: {
    dbTier: dbTier
    location: location
  }
}

module nsgCreate 'modules/vmnsg.bicep' = {
  name: 'deployment2'
  scope: resourceGroup()
  params: {
    location: location
    NSGGroups: NSGGroups
    // nsgrules: nsgrules
  }
  dependsOn: [
    dbCreate
  ]
}

module vnetCreate 'modules/vnet.bicep' = {
  name: 'deployment3'
  scope: resourceGroup()
  params: {
    vnets: vnets
    location: location
  }
  dependsOn: [
    dbCreate
  ]
}

module pipCreate 'modules/pip.bicep' = {
  name: 'deployment4'
  scope: resourceGroup()
  params: {
    pipObj: pipObj
    location: location
  }
  dependsOn: [
    dbCreate
    //vnetCreate
    nsgCreate
  ]
}

module nicCreate 'modules/nic.bicep' = {
  name: 'deployment5'
  scope: resourceGroup()
  params: {
    nicNames: nicNames
    location: location
  }
  dependsOn: [
    dbCreate
    vnetCreate
    pipCreate
  ]
}
