#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will return the IP of a specified container.
#
#   Inputs:
#       - containerName - container name
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#   Outputs:
#       - dbIp - IP of the specified container
#       - errorMessage - error message
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.containers

operations:
    - get_container_ip:
         inputs:
           - containerName
           - cmdParams:
                default: "''"
                overridable: false
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
                default: >
                    "docker inspect --format '{{ .NetworkSettings.IPAddress }}' " + containerName
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
           - dbIp: returnResult[:-1]
           - errorMessage: STDERR if returnCode == '0' else returnResult
         results:
           - SUCCESS : returnCode == '0' and (not 'Error' in STDERR)
           - FAILURE