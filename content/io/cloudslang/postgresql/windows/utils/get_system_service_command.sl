#   (c) Copyright 2019 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
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
#! @description: Get the PowerShell command to start/restart/stop/get status a postgres service
#!
#! @input service_name: service name
#! @input operation: operation name
#!
#! @output pwsh_command: PowerShell command
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#! @output return_code: Return code of the command
#! @output exception: Contains the stack trace in case of an exception
#!
#! @result SUCCESS: the command was executed successfully
#! @result FAILURE: There was an error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows.utils

operation:
  name: get_system_service_command

  inputs:
    - service_name:
        required: true
    - operation:
        required: true
  python_action:
    script: |
      pwsh_command = ''
      error_message =''
      if operation == 'start':
        pwsh_command = 'Start-Service -Name "' + service_name + '" -PassThru | Format-List status'
      elif operation == 'stop':
        pwsh_command = 'Stop-Service -Name "' + service_name + '" -PassThru | Format-List status'
      elif operation == 'restart' or operation == 'reload':
        pwsh_command = 'Get-Service -Name "' + service_name + '" | Restart-Service  -PassThru | Format-List status'
      elif operation == 'status':
        pwsh_command = 'Get-Service -Name "' + service_name + '" | Format-List status'
      else:
        error_message = 'Unknown or unsupported operation'
  outputs:
    - pwsh_command: ${pwsh_command}
    - exception: ${error_message}
    - return_code: ${"0" if error_message == '' else "-1"}
    - return_result: ${error_message}
  results:
    - FAILURE: ${error_message != ''}
    - SUCCESS
