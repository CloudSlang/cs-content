#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Runs a shell command locally.
#! @input command: command to run
#! @output return_result: output of the command
#! @output error_message: error in case something went wrong
#! @output return_code: 0 if command runs with success, -1 in case of failure
#! @result SUCCESS: if return_code is 0
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.cmd

operation:
  name: run_command
  inputs:
    - command

  python_action:
    script: |
      return_code = '0'
      return_result = ''
      error_message = ''
      try:
        import subprocess
        res = subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True);
        output,error = res.communicate()
        if output:
          return_result = output
          return_code = res.returncode
        if error:
          return_code = res.returncode
          error_message = error.strip()
      except Exception as e:
        error_message = e
        return_code = -1

  outputs:
    - return_result
    - error_message
    - return_code
  results:
    - SUCCESS: ${return_code == 0}
    - FAILURE
