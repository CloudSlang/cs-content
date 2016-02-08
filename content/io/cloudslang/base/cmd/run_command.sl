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
#! @result SUCCESS: exit code is 0
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.base.cmd

operation:
  name: run_command
  inputs:
    - command
  action:
    python_script: |
      import subprocess
      print "Running command: '" + command + "'"
      exit_code = subprocess.call(command, shell=True)
  results:
    - SUCCESS: ${exit_code == 0}
    - FAILURE
