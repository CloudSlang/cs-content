#   Copyright 2026 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Adds a local or domain user or group to the Windows VM's built-in local Administrators group over WinRM.
#!               The operation is idempotent and does not create the user or group.
#!
#! Notes:
#! - WinRM over HTTPS must be configured on the target.
#! - The target must support the PowerShell LocalAccounts cmdlets.
#! - The WinRM account must be authorized to manage local group membership.
#!
#! @input host: The hostname or IP address of the Windows VM.
#! @input port: The WinRM HTTPS port.
#!              Default: '5986'
#!              Optional
#! @input username: The WinRM account with permission to manage local group membership.
#! @input password: The password for the WinRM account.
#! @input member_identity: The local or domain user or group to add, for example 'HOST\\user' or 'DOMAIN\\group'.
#! @input auth_type: The WinRM authentication type.
#!                   Default: 'NTLM'
#!                   Optional
#! @input operation_timeout: The WinRM operation timeout in seconds.
#!                           Default: '60'
#!                           Optional
#! @input configuration_name: The PowerShell session configuration on the target.
#!                            Optional
#!
#! @output return_result: The PowerShell script result.
#! @output return_code: '0' if the member is present or was added; '-1' otherwise.
#! @output script_exit_code: The PowerShell script exit code.
#! @output stderr: The standard error output, if any.
#! @output exception: The exception details, if execution failed.
#!
#! @result SUCCESS: The member is already present or was added successfully.
#! @result FAILURE: WinRM or the group-membership update failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.nutanix.guest_os.windows.groups

imports:
  powershell: io.cloudslang.base.powershell.v2
  utils: io.cloudslang.base.utils

flow:
  name: add_member_to_local_administrators

  inputs:
    - host
    - port:
        default: '5986'
        required: false
    - username
    - password:
        sensitive: true
    - member_identity
    - auth_type:
        default: 'NTLM'
        required: false
    - operation_timeout:
        default: '60'
        required: false
    - configuration_name:
        required: false

  workflow:
    - encode_member_identity:
        do:
          utils.base64_encoder:
            - data: ${member_identity}
            - character_set: 'UTF-8'
        publish:
          - encoded_member_identity: ${result}

    - add_member_to_local_administrators:
        do:
          powershell.powershell_script:
            - host
            - port
            - protocol: 'https'
            - username
            - password
            - auth_type
            - configuration_name
            - operation_timeout
            - script: |
                $ErrorActionPreference = 'Stop'
                $memberIdentity = [System.Text.Encoding]::UTF8.GetString(
                    [System.Convert]::FromBase64String('${encoded_member_identity}'))
                $administratorsGroup = Get-LocalGroup -SID 'S-1-5-32-544' -ErrorAction Stop
                $memberAccount = [System.Security.Principal.NTAccount]::new($memberIdentity)
                $memberSid = $memberAccount.Translate([System.Security.Principal.SecurityIdentifier]).Value
                $existingMembers = Get-LocalGroupMember -Group $administratorsGroup.Name -ErrorAction Stop
                $isAlreadyMember = $existingMembers | Where-Object {
                    $_.SID -and $_.SID.Value -eq $memberSid
                }
                if ($isAlreadyMember) {
                    Write-Output "'$memberIdentity' is already a member of '$($administratorsGroup.Name)'."
                } else {
                    Add-LocalGroupMember -Group $administratorsGroup.Name -Member $memberIdentity -ErrorAction Stop
                    Write-Output "Added '$memberIdentity' to '$($administratorsGroup.Name)'."
                }
        publish:
          - return_code
          - return_result
          - script_exit_code
          - stderr
          - exception

  outputs:
    - return_code
    - return_result
    - script_exit_code
    - stderr
    - exception

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
