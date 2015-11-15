#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Set permission
#
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#   - path - to give permmition
#   - privateKeyFile - optional - absolute path to private key file - Default: none
# Outputs:
#   - error_Message - contains the STDERR of the machine if the SSH action was executed successfully, the cause of the exception otherwise
# Results:
#   - SUCCESS - action was executed successfully 
#   - FAILURE - some problem occurred, more information in errorMessage output
##################################################################################################################################################

namespace: io.cloudslang.base.os.linux

operation:
  name: give_permission
  inputs:
    - host
    - username
    - password
    - path
    - privateKeyFile:
        default: "''"
    - command:
        default: "'chmod +x '+path+''"
        overridable: false
  action:
    java_action:
      className: org.openscore.content.ssh.actions.SSHShellCommandAction
      methodName: runSshShellCommand
  outputs:
    - error_message:  STDERR if returnCode == '0' else returnResult
  results:
    - SUCCESS : returnCode == '0'
    - FAILURE
