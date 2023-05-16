param NSGGroups array
param nsgrules array

resource nsgs 'Microsoft.Network/networkSecurityGroups@2022-11-01' = [for nsg in NSGGroups: {
  name: nsg.Name
  location: nsg.location
  tags: nsg.tags
}]

resource nsgsRules 'Microsoft.Network/networkSecurityGroups/securityRules@2022-07-01' = [for (rule,i) in nsgrules: {
  name: rule.Name
  parent: nsgs[i]
  properties: rule.properties
}] 
