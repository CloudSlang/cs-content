#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
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
#! @output proc: command output
#! @output error_message: something went wrong
#! @result SUCCESS: command executed successfully
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
      import subprocess
      try:
        error_message = ""
        proc = subprocess.check_output(command)
      except Exception as e:
        error_message = e

  outputs:
    - proc
    - error_message
  results:
    - SUCCESS: ${error_message == None}
    - FAILURE
