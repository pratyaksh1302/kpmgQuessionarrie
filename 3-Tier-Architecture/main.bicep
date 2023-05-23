param location string = 'eastus'
param username string = ''
@secure()
param password string = ''
param deploymentUrl string = 'https://raw.githubusercontent.com/pratyaksh1302/kpmgQuessionarrie/main/3-Tier-Architecture/Deployment/'

param dbTier object = {
  sqlServerName: 'pratsqlserver'
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
 param sqlRules array = [
  {
    sqlSvrName: 'pratsqlserver'
    ruleName: 'demo-vnet-biz-rule'
    vnetName: 'demo-vnet'
    subnetName: 'app-subnet'
  }
 ]
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
param demovms array = [
  {
    name: 'demo-web-vm'
    tags: {
      tier: 'presentation'
    }
    nicName: 'web-nic'
    extName: 'apache-ext'
    settings: {
      skipDos2Unix: true
    }
    protectedSettings: {
      commandToExecute: 'sh setup-votingweb.sh'
      fileUris: [
        uri('${deploymentUrl}', 'setup-votingweb.sh')
        uri('${deploymentUrl}', 'votingweb.conf')
        uri('${deploymentUrl}', 'votingweb.service')
        uri('${deploymentUrl}', 'votingweb.zip')
      ]
    }
  }
  {
    name: 'demo-app-vm'
    tags: {
      tier: 'application'
    }
    nicName: 'app-nic'
    extName: 'apache-ext'
    settings: {
      skipDos2Unix: true
      fileUris: [
        uri('${deploymentUrl}', 'setup-votingdata.sh')
        uri('${deploymentUrl}', 'votingdata.conf')
        uri('${deploymentUrl}', 'votingdata.service')
        uri('${deploymentUrl}', 'votingdata.zip')
      ]
    }
    protectedSettings: {
      commandToExecute: 'sh setup-votingdata.sh ${dbTier.sqlServerName} ${username} ${password}'
    }
  }
]
module dbCreate 'modules/sqlsvr.bicep' = {
  name: 'deployment1'
  scope: resourceGroup()
  params: {
    dbTier: dbTier
    username: username
    password: password
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

module sqlSvrRuleCreate 'modules/sqlsvrRule.bicep' = {
  name: 'deploymentsqlRule'
  params: {
    sqlRules: sqlRules
  }
  dependsOn: [
    dbCreate
    vnetCreate
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
    // nsgCreate
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

module vmCreate 'modules/vm.bicep' = {
  name: 'vmdeployment'
  params: {
    demovms: demovms
    location: location
    password: password
    username: username
  }
  dependsOn: [
    dbCreate
    sqlSvrRuleCreate
    vnetCreate
    // nsgCreate
    nicCreate
    pipCreate
  ]
}
