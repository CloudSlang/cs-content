#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will start a linked container.
#
#   Inputs:
#       - dbContainerIp - IP of a container that contains MySql
#       - dbContainerName - Name of the container that contains MySql
#       - imageName - Image name
#       - containerName - Linked container name
#       - linkParams - Link parameters
#       - cmdParams - Command Parameters
#       - host - Linux machine IP
#       - port - optional - SSH port - Default: 22
#       - username: Username
#       - password: Password
#   Outputs:
#       - containerID - ID of the container that was started.
#       - errorMessage - error message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.containers

operations:
    - start_linked_container:
         inputs:
           - dbContainerIp
           - dbContainerName
           - imageName
           - containerName
           - linkParams
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
           - arguments:
                default: "''"
                override: true
           - command:
                default: "'docker run --name ' + containerName + ' --link ' + linkParams + ' ' + cmdParams + ' -d ' + imageName"
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
           - containerID: returnResult
           - errorMessage: STDERR if returnCode == '0' else returnResult
         results:
           - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
           - FAILURE