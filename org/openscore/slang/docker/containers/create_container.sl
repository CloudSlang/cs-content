#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will create a Docker container.
#
#   Inputs:
#       - imageID - Docker image that will be assigned to the container
#       - containerName - container name
#       - cmdParams - command parameters
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#   Outputs:
#       - dbContainerID - ID of the container
#       - errorMessage - error message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.containers

operations:

  - create_container:
      inputs:
        - imageID
        - containerName
        - cmdParams:
            default: "''"
            required: false
        - containerCmd:
            default: "''"
            required: false
        - host
        - port:
            default: "'22'"
            required: false
        - username
        - password
        - privateKeyFile:
            default: "''"
            overridable: false
        - command:
            default: "'docker run -d --name ' + containerName + ' ' + cmdParams + ' ' + imageID + ' ' + containerCmd"
            overridable: false
        - arguments:
            default: "''"
            overridable: false
        - characterSet:
            default: "'UTF-8'"
            overridable: false
        - pty:
            default: "'false'"
            overridable: false
        - timeout:
            default: "'90000'"
            overridable: false
        - closeSession:
            default: "'false'"
            overridable: false
      action:
        java_action:
          className: org.openscore.content.ssh.actions.SSHShellCommandAction
          methodName: runSshShellCommand
      outputs:
        - dbContainerID: returnResult
        - errorMessage: STDERR if returnCode == '0' else returnResult
      results:
        - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
        - FAILURE