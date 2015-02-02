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
#       - dbContainerIp - IP of a container that contains MySQL
#       - dbContainerName - name of the container that contains MySQL
#       - imageName - image name
#       - containerName - linked container name
#       - linkParams - link parameters
#       - cmdParams - command Parameters
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username: Docker machine username
#       - password: Docker machine password
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
                overridable: false
           - arguments:
                default: "''"
                overridable: false
           - command:
                default: "'docker run --name ' + containerName + ' --link ' + linkParams + ' ' + cmdParams + ' -d ' + imageName"
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
           - containerID: returnResult
           - errorMessage: STDERR if returnCode == '0' else returnResult
         results:
           - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
           - FAILURE