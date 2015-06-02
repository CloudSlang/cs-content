#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Install docker machine on Windows, OSX
#
# Inputs:
#   - host - Docker machine host
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
#   - distro - distrebution to use can be one pf the follow: docker-machine_darwin-amd64,docker-machine_darwin-386,docker-machine_linux-amd64,docker-machine_linux-386
#   - version - docker machine version to install default v0.2.0
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.docker_machine.install_docker_machine

imports:
 docker_install: io.cloudslang.docker.docker_machine.install_docker_machine
 linux: io.cloudslang.base.os.linux

flow:
  name: install_docker_machine
  inputs:
    - host
    - username
    - password
    - distro
    - version:
        default: "'v0.2.0'"
    - privateKeyFile:
        default: "''"
    - path:
        default: "'/usr/local/bin/docker-machine'"
        overridable: false
  workflow:
    - download_binary:
        do:
          docker_install.download_binary:
            - host
            - username
            - password
            - privateKeyFile
            - distro
            - version
        publish:
          - error_message

    - give_docker_machine_permission:
        do:
          linux.give_permission:
            - host
            - username
            - password
            - privateKeyFile
            - path
        publish:
          - error_message
