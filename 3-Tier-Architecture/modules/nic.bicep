param nicNames array 

resource webVMNicName 'Microsoft.Network/networkInterfaces@2018-08-01' = [for nic in nicNames: {
  name: nic.name
  location: nic.location
  tags: {
    tier: nic.tier
  }
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.1.0.4'
          privateIPAllocationMethod:contains(nic, 'privateIPAllocationMethod') ? nic.privateIPAllocationMethod : 'Static'
          publicIPAddress: contains(nic, 'publicIPAddress') ? {
            id: nic.pipId
          } : null
          subnet: {
            id: nic.subnetid
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
      id: nic.nsgId
    }
  }
}]
