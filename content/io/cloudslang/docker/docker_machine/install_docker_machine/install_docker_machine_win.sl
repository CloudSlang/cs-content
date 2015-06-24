#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Install docker machine on Windows
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#   - distro - optional - distrebution to use can be one pf the follow: docker-machine_darwin-amd64,docker-machine_darwin-386,docker-machine_linux-amd64,docker-machine_linux-386
#   - version - docker machine version to install default v0.2.0
#   - path - optional - path to save the docker installetion files
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.docker_machine.install_docker_machine

imports:
 WinRM: io.cloudslang.base.remote_command_execution.WinRM

flow:
  name: install_docker_machine_win
  inputs:
    - host
    - username
    - password
    - distro
    - version:
        default: "'v0.2.0'"
    - path:
        default: "'C:/Program Files/docker'"
  workflow:
    - install_docker_client:
        do:
          WinRM.win_command:
            - host
            - username
            - password
            - command: "'curl -L https://get.docker.com/builds/Windows/x86_64/docker-latest.exe > '+path"
        publish:
          - error_message

    - give_docker_machine_permission:
        do:
          WinRM.win_command:
            - host
            - username
            - password
            - command: "'curl -L https://github.com/docker/machine/releases/download/v0.2.0/docker-machine_windows-amd64.exe > '+path"
        publish:
          - error_message
