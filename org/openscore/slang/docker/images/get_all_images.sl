#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will return a list populated with all docker images
#
#   Inputs:
#       - host - Linux machine IP
#       - port - optional - SSH port - Default: 22
#       - username - Username
#       - password - Password
#   Outputs:
#       - imageList
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################
namespace: org.openscore.slang.docker.images

operations:
    - get_all_images:
          inputs:
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
                default: >
                    "docker images | awk '{print $1 \":\" $2}'"
                required: false
            - arguments:
                default: "''"
                required: false
            - characterSet:
                default: "'UTF-8'"
                required: false
            - pty:
                default: "'false'"
                required: false
            - timeout:
                default: "'30000000'"
                override: true
            - closeSession:
                default: "'false'"
                override: true
          action:
            java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
          outputs:
            - imageList: returnResult.replace("\n"," ").replace("<none>:<none> ","").replace("REPOSITORY:TAG ","")
          results:
            - SUCCESS
            - FAILURE