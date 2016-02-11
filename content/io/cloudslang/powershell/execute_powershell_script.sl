#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Executes a PowerShell script on a given remote host.
#! @input host: hostname or IP address of PowerShell host
#! @input user_name: username used to connect to remote machine
#! @input password: password used to connect to remote machine
#! @input script: PowerShell script that will run on remote machine
#! @input winrm_enable_https: if true, HTTPS is used to connect to the WinRM server,
#!                            otherwise, HTTP is used
#!                            optional
#!                            default: false
#! @output return_result: output of PowerShell script
#! @output return_code: status code of execution
#! @output error_message: error
#!!#
####################################################
namespace: io.cloudslang.powershell

operation:
  name: execute_powershell_script
  inputs:
    - host
    - user_name
    - userName:
        default: ${get('user_name', None)}
    - password
    - script
    - connectionType:
        default: "WINRM_NATIVE"
        overridable: false
    - winrm_enable_https:
        required: false
    - winrmEnableHTTPS:
        default: ${get('winrm_enable_https', 'false')}
        required: false
  action:
    java_action:
      className: io.cloudslang.content.actions.PowerShellScriptAction
      methodName: execute
  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - error_message: ${exception}
  results:
    - SUCCESS : ${returnCode == '0'}
    - FAILURE
