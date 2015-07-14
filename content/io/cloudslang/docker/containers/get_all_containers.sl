#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of all the Docker container IDs.
#
# Inputs:
#   - all_containers - adds all_container option to docker command. False by default, any input changes it to True
#   - ps_params - option trigger to add all_containers option to docker command
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - arguments - optional - arguments to pass to the command
#   - characterSet - optional - character encoding used for input stream encoding from target machine; Valid: SJIS, EUC-JP, UTF-8 - Default: UTF-8
#   - pty - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for command to complete - Default: 30000000
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
# Outputs:
#   - container_list - list containing container ID for all the Docker containers, separated by space
# Results:
#   - SUCCESS - SSH command succeeded
#   - FAILURE - SSH command failed
####################################################

namespace: io.cloudslang.docker.containers

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: get_all_containers
  inputs:
    - all_containers:
        default: False
    - ps_params:
        default: " '-a' if bool(all_containers) else ''"
    - command: "'docker ps -q ' + ps_params"
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

  workflow:
    - get_all_containers:
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
          - container_list: returnResult.replace("\n"," ").strip()

  outputs:
    - container_list
