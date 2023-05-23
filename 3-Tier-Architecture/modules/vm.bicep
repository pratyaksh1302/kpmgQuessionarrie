param demovms array
// param demoexts array
param location string
param username string
@secure()
param password string

resource webVMName 'Microsoft.Compute/virtualMachines@2023-03-01' = [for (vm, i) in demovms: {
  name: vm.name
  location: location
  tags: vm.tags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${vm.name}-disk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vm.name
      adminUsername: username
      adminPassword: password
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', vm.nicName)
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }

  }
}]

resource webVMName_apache_ext 'Microsoft.Compute/virtualMachines/extensions@2018-10-01' = [for (vmext,i) in demovms: {
  parent: webVMName[i]
  name: vmext.extName
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
    settings: vmext.settings
    protectedSettings: vmext.protectedSettings
  }
}]


