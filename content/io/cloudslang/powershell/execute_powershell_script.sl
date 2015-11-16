#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes PowerShell script on a given remote host.
#
# Inputs:
#   - host - the hostname or IP address of the PowerShell host
#   - user_name - The username used to connect to the the remote machine.
#   - password - The password used to connect to the remote machine.
#   - script - The PowerShell script that will run on the remote machine.
#   - connection_type - Specifies what protocol is used to execute commands on the remote hosts.
#                       One of the following values must be set:
#                       WINRM_INTERNAL - uses WinRM over HTTP(S) to execute remote commands.
#                          The default value for the port is 5985 for HTTP and 5986 for HTTPS.
#                          A Java implementation of WinRM used.
#                       WINRM_NATIVE - uses WinRM over HTTP(S) to execute remote commands.
#                          The default value for the port is 5985 for HTTP and 5986 for HTTPS.
#                          The native Windows implementation of WinRM is used, i.e. the winrs command.
#                       TELNET - uses Telnet to execute remote commands. The port connection option
#                          specifies the Telnet port to connect to. The default value is 23.
#   - winrm_enable_https - If set to true, HTTPS is used to connect to the WinRM server. Otherwise HTTP is used.
#                         The default value is false. This connection option is only applicable for
#                         the WINRM_INTERNAL and WINRM_NATIVE connection types.
# Outputs:
#   - return_result - output of the powershell script
#   - status_code - status code of the execution
#   - error_message - error
####################################################
namespace: io.cloudslang.powershell

operation:
  name: execute_powershell_script
  inputs:
    - host
    - user_name
    - userName:
        default: get('user_name', None)
    - password
    - script
    - connection_type
    - connectionType:
        default: get('connection_type', None)
    - winrm_enable_https:
        required: false
    - winrmEnableHTTPS:
        default: get('winrm_enable_https', None)
        required: false
  action:
    java_action:
      className: io.cloudslang.content.actions.PowerShellScriptAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - return_code: returnCode
    - error_message: exception