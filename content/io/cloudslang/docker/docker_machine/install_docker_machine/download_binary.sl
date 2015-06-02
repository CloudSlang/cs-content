#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
# Download docker machine binary for on Windows, OSX
#
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - distro - distrebution to use can be one pf the follow: docker-machine_darwin-amd64,docker-machine_darwin-386,docker-machine_linux-amd64,docker-machine_linux-386
#   - version - docker machine version to install default v0.2.0
# Outputs:
#   - error_Message - contains the STDERR of the machine if the SSH action was executed successfully, the cause of the exception otherwise
# Results:
#   - SUCCESS - action was executed successfully 
#   - FAILURE - some problem occurred, more information in errorMessage output
##################################################################################################################################################

namespace: io.cloudslang.docker.docker_machine.install_docker_machine

operation:
  name: download_binary
  inputs:
    - host
    - username
    - password
    - privateKeyFile:
        default: "''"
    - distro
    - version:
        default: "'v0.2.0'"
    - command:
        default: "'curl -L https://github.com/docker/machine/releases/download/'+version+'/'+distro+' > /usr/local/bin/docker-machine'"
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
