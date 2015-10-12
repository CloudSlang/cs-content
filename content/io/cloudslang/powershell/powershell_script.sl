#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes PowerShell script on a given host.
#
# Inputs:
#   - host - the hostname or IP address of the PowerShell host
#   - username - the username to use when connecting to the server
#   - password - The password to use when connecting to the server
#   - script - the script to execute on the PowerShell host
# Outputs:
#   - return_result - output of the powershell script
#   - status_code - status code of the execution
#   - error_message - error
# Results:
#   - SUCCESS - execution was successful
#   - FAILURE - execution of the powershell script failed
####################################################
namespace: io.cloudslang.powershell

operation:
  name: powershell_script
  inputs:
    - host
    - username
    - password
    - script
  action:
    python_script: |
      import winrm
      s = winrm.Session(host, auth=(username, password))
      r = s.run_ps(script)
      return_result = r.std_out
      status_code = r.status_code
      error_message = r.std_err
  outputs:
    - return_result
    - status_code
    - error_message
  results:
    - SUCCESS
    - FAILURE