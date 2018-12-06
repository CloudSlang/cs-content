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
      elif operation == 'restart':
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
