#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Create a new docker machine via ssh
#
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - driver - new docker machine driver
#   - machine_name - new docker machine name
#   - path_to_docker_machine - optional - installetion path of docker machine
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.docker_machine

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: create
  inputs:
    - host
    - username
    - password
    - privateKeyFile:
        default: "''"
    - driver
    - machine_name
    - path_to_docker_machine:
        default: "''"
    - create_command:
        default: "path_to_docker_machine + 'docker-machine create --driver ' + driver + ' ' + machine_name"
        overridable: false
    - tmp:
        default: > 
            "\""
        overridable: false
    - set_environment_variables_command:
        default: "'eval ' + tmp + '$(' + path_to_docker_machine + 'docker-machine env ' + machine_name + ')' + tmp"
        overridable: false
  workflow:
    - run_remote_create_command:
        do:
          ssh.ssh_flow:
            - host
            - username
            - password
            - privateKeyFile
            - command: create_command
        publish:
          - result: returnResult.replace("\n","")
          - standard_out
          - standard_err
          - exception

    - set_environment_variables:
        do:
          ssh.ssh_flow:
            - host
            - username
            - password
            - privateKeyFile
            - command: set_environment_variables_command
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