param nicNames array 
param location string

resource webVMNicName 'Microsoft.Network/networkInterfaces@2018-08-01' = [for nic in nicNames: {
  name: nic.name
  location: location
  tags: {
    tier: nic.tier
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: nic.privateIPAddress
          privateIPAllocationMethod:contains(nic, 'privateIPAllocationMethod') ? nic.privateIPAllocationMethod : 'Static'
          publicIPAddress: contains(nic, 'publicIPAddress') ? {
            id: resourceId('Microsoft.Network/publicIPAddresses', nic.publicIPAddress.publicIpAddressName)
          } : null
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', nic.vnetName, nic.subnetName)
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    primary: true
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', nic.networkSecurityGroup.nsgName)
    }
  }
}]
