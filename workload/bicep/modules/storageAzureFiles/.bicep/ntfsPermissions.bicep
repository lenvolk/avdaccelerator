// ========== //
// Parameters //
// ========== //

param artifactsLocation string

// @secure()
// param _artifactsLocationSasToken string

param commandToExecute string

@sys.description('Name for management virtual machine. for tools and to join Azure Files to domain.')
param managementVmName string

@secure()
@sys.description('Domain join user password.')
param  domainJoinUserPassword string

@sys.description('Location where to deploy compute services.')
param location string

@sys.description('Do not modify, used to set unique value for resource deployment.')
param time string = utcNow()

// =========== //
// Variable declaration //
// =========== //

var varCommandToExecute = '${commandToExecute} -DomainAdminUserPassword ${domainJoinUserPassword} -verbose'

// =========== //
// Deployments //
// =========== //

resource customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${managementVmName}/CustomScriptExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        '${artifactsLocation}Set-NtfsPermissions.ps1'//${_artifactsLocationSasToken}'
      ]
      timestamp: time
    }
    protectedSettings: {
      commandToExecute: varCommandToExecute
    }
  }
}
