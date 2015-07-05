#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Inspects Docker image.
#
# Inputs:
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - imageID - ID of the image to be inspected
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for command to complete
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - standard_out - STDOUT of the machine in case of successful request
#   - standard_err - STDERR of the machine in case of successful request
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: inspect_image
  inputs:
    - docker_options:
        required: false
    - docker_options_expression:
        default: docker_options + ' ' if bool(docker_options) else ''
        overridable: false
    - image_name
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - privateKeyFile:
        required: false
    - command:
        default: "'docker ' + docker_options_expression + 'inspect ' + image_name"
        overridable: false
    - characterSet:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - closeSession:
        required: false
    - agent_forwarding:
        required: false
  workflow:
    - get_used_images:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                required: false
            - command
            - characterSet:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                required: false
            - agentForwarding:
                required: false
        publish:
            - standard_out
            - standard_err
  outputs:
     - standard_out
     - standard_err