#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will return a list populated with used docker images
#
#   Inputs:
#       - host - Linux machine IP
#       - port - optional - SSH port - Default: 22
#       - username - Username
#       - password  - Password
#   Outputs:
#       - imageList
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.images

operations:
    - get_used_images:
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
                "docker ps -a | awk '{print $2}'"
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
           - imageList: returnResult.replace("\n"," ").replace("ID ","",1)
         results:
           - SUCCESS
           - FAILURE