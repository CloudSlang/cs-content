#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will create a docker container.
#
#   Inputs:
#       - imageID - docker image that will be assigned to the container
#       - containerName - Container name
#       - cmdParams - Command parameters
#       - host - Linux machine IP
#       - port - optional - SSH port - Default: 22
#       - username - Username
#       - password - Password
#   Outputs:
#       - dbContainerID - ID of the container
#       - errorMessage
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
        - cmdParams
        - host
        - port:
            default: "'22'"
            required: false
        - username
        - password
        - privateKeyFile:
            default: "''"
            override: true
        - command:
            default: "'docker run --name ' + containerName + ' ' +cmdParams + ' -d ' + imageID"
            override: true
        - arguments:
            default: "''"
            override: true
        - characterSet:
            default: "'UTF-8'"
            override: true
        - pty:
            default: "'false'"
            override: true
        - timeout:
            default: "'90000'"
            override: true
        - closeSession:
            default: "'false'"
            override: true
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