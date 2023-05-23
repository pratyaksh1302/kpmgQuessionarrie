param pipObj object
param location string

resource webVMNicPIPName 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  name: pipObj.name
  location: location
  tags: {
    tier: 'presentation'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}
