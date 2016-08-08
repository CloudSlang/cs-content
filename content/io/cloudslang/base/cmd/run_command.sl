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
#! @input cwd: current working directory
#!            If cwd is not None, the child’s current directory will be changed to cwd before it is executed.
#!            Note that this directory is not considered when searching the executable,
#!            so you can’t specify the program’s path relative to cwd
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
    - cwd:
        required: false
        default: None

  python_action:
    script: |
      import os
      import subprocess
      return_code = 0
      return_result = ''
      error_message = ''
      cwd = os.getcwd() if cwd is not None else cwd
      try:
        res = subprocess.Popen(command,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True);
        output,error = res.communicate()
        if output:
          return_result = output
          return_code = res.returncode
        if error:
          return_code = res.returncode
          error_message = error.strip()
      except Exception as e:
        return_code = -1
        error_message = e

  outputs:
    - return_result
    - return_code
    - error_message

  results:
    - SUCCESS: ${return_code == 0}
    - FAILURE
