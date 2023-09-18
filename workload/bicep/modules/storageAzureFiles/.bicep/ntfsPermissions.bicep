// ========== //
// Parameters //
// ========== //

param _artifactsLocation string
@secure()
param _artifactsLocationSasToken string

param CommandToExecute string

param ManagementVmName string

param Timestamp string

@sys.description('Arguments for domain join script.')
param scriptArguments string

@secure()
@sys.description('Domain join user password.')
param  domainJoinUserPassword string

// =========== //
// Variable declaration //
// =========== //

var varscriptArgumentsWithPassword = '${scriptArguments} -DomainAdminUserPassword ${domainJoinUserPassword} -verbose'

// =========== //
// Deployments //
// =========== //

resource customScriptExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = {
  name: '${ManagementVmName}/CustomScriptExtension'
  location: Location
  //tags: TagsVirtualMachines
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      fileUris: [
        '${_artifactsLocation}Set-NtfsPermissions.ps1${_artifactsLocationSasToken}'
      ]
      timestamp: Timestamp
    }
    protectedSettings: {
      commandToExecute: CommandToExecute
    }
  }
}
