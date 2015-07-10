#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Pulls and runs a Docker container.
#
# Inputs:
#   - docker_options - optional - options for the docker environment - from the construct: docker [OPTIONS] COMMAND [arg...]
#   - detach - optional - run container in background (detached / daemon mode) - Default: true
#   - container_name - optional - container name
#   - container_params - optional - command parameters
#   - container_command - optional - container command
#   - image_name - Docker image that will be assigned to the container
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - arguments - optional - arguments to pass to command
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
#   - agentForwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - container_ID - ID of the container
#   - standard_err - STDERR of the machine in case of successful request, null otherwise
####################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  images: io.cloudslang.docker.images

flow:
  name: run_container
  inputs:
    - docker_options:
        required: false
    - detach:
        default: true
    - container_name:
        required: false
    - container_params:
        required: false
    - container_command:
        required: false
    - image_name
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - arguments:
        required: false
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
    - docker_options_expression:
        default: "(docker_options + ' ') if bool(docker_options) else ''"
        overridable: false
    - detach_expression:
        default: "'-d ' if detach else ''"
        overridable: false
    - container_name_param:
        default: "'--name ' + container_name + ' ' if bool(container_name) else ''"
        overridable: false
    - container_params_cmd:
        default: "container_params + ' ' if bool(container_params) else ''"
        overridable: false
    - container_command_cmd:
        default: "' ' + container_command if bool(container_command) else ''"
        overridable: false
    - command:
        default: "'docker ' + docker_options_expression + 'run ' + detach_expression + container_name_param + container_params_cmd + image_name + container_command_cmd"
        overridable: false

  workflow:
    - run_container:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - command
            - arguments:
                required: false
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
          - container_ID: standard_out[:-1]
          - standard_err
  outputs:
    - container_ID
    - standard_err
