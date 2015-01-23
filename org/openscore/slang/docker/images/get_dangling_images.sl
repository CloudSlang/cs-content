#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will return a list populated with all docker dangling images.
#
#   Inputs:
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#   Outputs:
#       - danglingImageList - list containing ids of docker dangling images
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################

namespace: org.openscore.slang.docker.images

operations:
    - get_dangling_images:
        inputs:
          - host
          - port: "'22'"
          - username
          - password
          - privateKeyFile: "''"
          - command: >
              "docker images -f \"dangling=true\" -q"
          - arguments: "''"
          - characterSet : "'UTF-8'"
          - pty: "'false'"
          - timeout: "'30000000'"
          - closeSession: "'false'"
        action:
          java_action:
            className: org.openscore.content.ssh.actions.SSHShellCommandAction
            methodName: runSshShellCommand
        outputs:
          - danglingImageList: returnResult
        results:
          - SUCCESS
          - FAILURE