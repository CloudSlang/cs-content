########################################################################################################################
#!!
#! @description: Get the PowerShell command to get a postgres service process info
#!
#! @input service_name: service name
#!
#! @output pwsh_command: PowerShell command
#! @output return_result: STDOUT of the remote machine in case of success or the cause of the error in case of exception
#!                        Example of the command:
#!                          Name      : postgresql
#!                          ProcessId : 2436
#!                          StartMode : Auto
#!                          State     : Running
#!                          Status    : OK
#! @output return_code: Return code of the command
#! @output exception: Contains the stack trace in case of an exception
#!
#! @result SUCCESS: the command was executed successfully
#! @result FAILURE: There was an error
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows.utils

operation:
  name: get_system_service_process_info_command

  inputs:
    - service_name:
        required: true
  python_action:
    script: |
      pwsh_command = 'Get-WMIObject win32_service | Where-Object {$_.Name -eq "' + service_name + '"}'
  outputs:
    - pwsh_command: ${pwsh_command}
    - return_code: ${"0"}
  results:
    - SUCCESS
