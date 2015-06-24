#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Run remote command on windows server using WinRm
#
# Inputs:
#   - host - hostname or IP address
#   - command - command to execute
#   - username - username to connect as
#   - password - password of user
# Outputs:
#   - error_message - error message if error occurred
#   - std_out- command output
#   - status_code- command status code
# Results:
#   - SUCCESS - command execution successed 
#   - FAILURE - command execution failed 
####################################################

namespace: io.cloudslang.base.remote_command_execution.WinRM

operation:
  name: win_command
  inputs:
    - host
    - username
    - password
    - command
  action:
    python_script: |
      from winrm import winrm
      error_message = ""
      try:
        s = winrm.Session(host, auth=(username, password))
        r=s.run_cmd(command)
        status_code= r.status_code
        std_out= r.std_out
        error_message = r.std_err
      except ValueError:
          error_message = "Exception"
  outputs:
    - error_message
    - std_out
    - status_code
  results:
    - SUCCESS: status_code == '0'
    - FAILURE