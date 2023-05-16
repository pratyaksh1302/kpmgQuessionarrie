param vnets object

resource vnetName 'Microsoft.Network/virtualNetworks@2018-08-01' = {
  name: vnets.name
  location: vnets.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnets.addressPrefix
      ]
    }
    subnets: [
      {
        name: vnets.webSubnetName
        properties: {
          addressPrefix: vnets.webSubnetPrefix
        }
      }
      {
        name: vnets.bizSubnetName
        properties: {
          addressPrefix: vnets.bizSubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Sql'
              locations: [
                vnets.location
              ]
            }
          ]
        }
      }
    ]
  }
}
