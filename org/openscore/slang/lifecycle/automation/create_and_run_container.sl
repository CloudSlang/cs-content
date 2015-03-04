#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This operation creates and runs a Docker container from a Docker image.
#
#   Inputs:
#       - docker_user - Docker username of the image; it should be the same as the Docker Hub username
#       - image_name - name of the Docker image
#       - version - version(tag) of the Docker image
#       - host - Docker machine host
#       - port - Docker machine port
#       - username - Docker machine username
#       - password - Docker machine password
#       - expose_host_port - port of the Docker host that will be used for accessing the container
#       - expose_container_port - port of the Docker container that will be used for accessing the container
#                                 this port must also be exposed in the container
#       - pty - whether to use pty; valid values: true, false; Default: false
#       - arguments - arguments to pass to the command; Default: none
#       - privateKeyFile - the absolute path to the private key file; Default: none
#       - timeout - time in milliseconds to wait for the command to complete; Default: 90000 ms
#       - characterSet - character encoding used for input stream encoding from the target machine; valid values: SJIS, EUC-JP, UTF-8; Default: UTF-8;
#       - closeSession - if false the ssh session will be cached for future calls of this operation during the life of the flow
#                        if true the ssh session used by this operation will be closed; Valid values: true, false; Default: false
#
#   Results:
#       - SUCCESS - the action returnCode is 0 (executed without exceptions) and the STDERR of the machine contains no errors
#       - FAILURE
##################################################################################################################################################

namespace: org.openscore.slang.lifecycle.automation

operation:
    name: create_and_run_container
    inputs:
        - docker_user
        - image_name
        - version
        - host
        - port:
            default: "'22'"
        - username
        - password
        - privateKeyFile:
            default: "''"
        - arguments:
            default: "''"
        - expose_host_port
        - expose_container_port
        - command:
            default: >
                'docker run -p ' + expose_host_port + ':' + expose_container_port + ' -t -i ' + docker_user + '/' + image_name + ':' + version
            override: true
        - characterSet:
            default: "'UTF-8'"
        - pty:
            default: "'false'"
        - timeout:
            default: "'90000'"
        - closeSession:
            default: "'false'"
    action:
      java_action:
          className: org.openscore.content.ssh.actions.SSHShellCommandAction
          methodName: runSshShellCommand
    results:
      - SUCCESS: returnCode == '0' and (not 'Error' in STDERR)
      - FAILURE
