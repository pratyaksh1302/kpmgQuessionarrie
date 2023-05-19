param dbTier object
param location string


resource sqlServerName_resource 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: dbTier.sqlServerName
  location: location
  tags: {
    tier: 'data'
  }
  
  properties: {
    administratorLogin: dbTier.username
    administratorLoginPassword: dbTier.password
    version: '12.0'
  }
}

resource sqlServerName_sqlServerDatabaseName 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServerName_resource
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
  name: '${sqlServerName_resource.name}-DB'
  location: location
  tags: {
    tier: 'data'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}
