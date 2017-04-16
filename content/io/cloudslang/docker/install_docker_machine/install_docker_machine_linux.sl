#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# Install docker machine on linux 64 bit
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port - Default: 22
#   - username - Docker machine username
#   - password - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file - Default: none
# Results:
#   - SUCCESS
#   - FAILURE
####################################################
namespace: io.cloudslang.docker.install

imports:
 docker_install: io.cloudslang.docker.install_docker_machine

flow:
  name: install_docker_machine_linux
  inputs:
    - host
    - port:
        default: "'22'"
    - username
    - password
    - privateKeyFile:
        default: "''"
  workflow:
    - download_binary:
        do:
          docker_install.linux_download_binary:
            - host
            - port
            - username
            - password
            - privateKeyFile
        publish:
          - error_message

    - give_docker_machine_permission:
        do:
          docker_install.give_docker_machine_permission:
            - host
            - port
            - username
            - password
            - privateKeyFile
        publish:
          - error_message
