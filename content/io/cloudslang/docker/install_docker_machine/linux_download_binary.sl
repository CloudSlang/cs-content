#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Download docker machine binary for linux 64 bit
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
# Outputs:
#   - error_Message - contains the STDERR of the machine if the SSH action was executed successfully, the cause of the exception otherwise
# Results:
#   - SUCCESS - action was executed successfully 
#   - FAILURE - some problem occurred, more information in errorMessage output
##################################################################################################################################################

namespace: io.cloudslang.docker.install

operation:
  name: linux_download_binary
  inputs:
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
    - command:
        default: "'curl -L https://github.com/docker/machine/releases/download/v0.2.0/docker-machine_linux-amd64 > /usr/local/bin/docker-machine'"
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
