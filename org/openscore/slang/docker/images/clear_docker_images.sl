#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will delete Docker images specified in the input.
#
#   Inputs:
#       - host - Docker machine host
#       - port - optional - SSH port - Default: 22
#       - username - Docker machine username
#       - password - Docker machine password
#       - images - list of Docker images to be deleted separated by space(" ")
#   Outputs:
#       - response - ID of the deleted images
#   Results:
#       - SUCCESS
#       - FAILURE
####################################################
namespace: org.openscore.slang.docker.images

operations:
    - clear_docker_images:
        inputs:
          - host
          - port:
                default: "'22'"
                required: false
          - username
          - password
          - images
          - privateKeyFile:
                default: "''"
                overridable: false
          - command:
                default: "'docker rmi ' + images"
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
          - response: STDOUT
        results:
          - SUCCESS
          - FAILURE