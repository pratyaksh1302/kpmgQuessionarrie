param NSGGroups array
// param nsgrules array
param location string

resource nsgs 'Microsoft.Network/networkSecurityGroups@2022-11-01' = [for (nsg,i) in NSGGroups: {
  name: nsg.Name
  location: location
  tags: nsg.tags
}]

// resource nsgsRules 'Microsoft.Network/networkSecurityGroups/securityRules@2022-07-01' = [for (rule,i) in nsgrules: {
//   name: rule.Name
//   parent: nsgs[i]
//   properties: rule.properties
// }]

output nsgResourceId1 string = nsgs[0].id
output nsgResourceId2 string = nsgs[1].id
