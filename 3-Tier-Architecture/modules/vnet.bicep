param vnets object
param location string

resource vnetName 'Microsoft.Network/virtualNetworks@2018-08-01' = {
  name: vnets.name
  location: location
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
        name: vnets.appSubnetName
        properties: {
          addressPrefix: vnets.appSubnetPrefix
          serviceEndpoints: [
            {
              service: 'Microsoft.Sql'
              locations: [
                location
              ]
            }
          ]
        }
      }
    ]
  }
}
