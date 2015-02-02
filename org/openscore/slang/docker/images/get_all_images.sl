#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will return a list populated with all Docker images.
#
#   Inputs:
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#   Outputs:
#       - imageList - list containing all Docker images' REPOSITORY and TAG
#   Results:
#       - SUCCESS - SSH command succeeds
#       - FAILURE - SSH command fails
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
                overridable: false
            - command:
                default: >
                    "docker images | awk '{print $1 \":\" $2}'"
            - arguments:
                default: "''"
            - characterSet:
                default: "'UTF-8'"
            - pty:
                default: "'false'"
            - timeout:
                default: "'30000000'"
                overridable: false
            - closeSession:
                default: "'false'"
                overridable: false
          action:
            java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
          outputs:
            - imageList: returnResult.replace("\n"," ").replace("<none>:<none> ","").replace("REPOSITORY:TAG ","")
          results:
            - SUCCESS
            - FAILURE