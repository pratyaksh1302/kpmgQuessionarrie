param sqlRules array

resource sqlServerName_demo_vnet_biz_rule 'Microsoft.Sql/servers/virtualNetworkRules@2022-08-01-preview' = [for rule in sqlRules: {
  name: '${rule.sqlSvrName}/${rule.ruleName}'
  properties: {
    ignoreMissingVnetServiceEndpoint: false
    virtualNetworkSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', rule.vnetname, rule.subnetname)
  }
}]
