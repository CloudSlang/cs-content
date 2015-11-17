#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Run docker machine ls command using ssh
#
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - path_to_docker_machine - optional - installetion path of docker machine
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.docker_machine

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: ls
  inputs:
    - host
    - username
    - password
    - privateKeyFile:
        default: "''"
    - path_to_docker_machine:
        default: "''"
    - command:
        default: "path_to_docker_machine + 'docker-machine ls'"
        overridable: false
  workflow:
    - run_ls_command:
        do:
          ssh.ssh_flow:
            - host
            - username
            - password
            - privateKeyFile
            - command
        publish:
          - result: returnResult.replace("\n","")
          - standard_out
          - standard_err
          - exception

  outputs:
    - result
    - standard_err
    - standard_out
    - exception