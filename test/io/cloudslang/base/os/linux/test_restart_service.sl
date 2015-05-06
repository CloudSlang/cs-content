#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.os.linux

imports:
  images: io.cloudslang.docker.images
  containers: io.cloudslang.docker.containers
  linux: io.cloudslang.base.os.linux
  ssh: io.cloudslang.base.remote_command_execution.ssh
  cmd: io.cludslang.base.cmd

flow:
  name: test_restart_service
  inputs:
    - host
    - port
    - username
    - password
    - service_name

  workflow:
    - pull_test_image:
        do:
          cmd.run_command:
            - command: "'docker pull rastasheep/ubuntu-sshd'"
        navigate:
          SUCCESS: start_docker
          FAILURE: FAIL_PULL_IMAGE

    - start_docker:
        do:
          cmd.run_command:
            - command: "'docker run -d -P -p 49160:22 --name test_sshd rastasheep/ubuntu-sshd'"
        navigate:
          SUCCESS: restart_service
          FAILURE: FAIL_START_DOCKER

    - restart_service:
        do:
          linux.restart_service:
            - host:
                default: "'localhost'"
                overridable: false
            - port:
                default: "'49160'"
                overridable: false
            - username
            - password:
                default: "'root'"
                overridable: false
            - service_name: service_name
        navigate:
          SUCCESS: stop_test_container
          FAILURE: FAILURE

    - stop_test_container:
        do:
          containers.stop_container:
            - host
            - port
            - username
            - password
            - containerID: "'test_sshd'"
        navigate:
          SUCCESS: delete_test_container
          FAILURE: FAIL_STOP_CONTAINER

    - delete_test_container:
        do:
          containers.delete_container:
            - host
            - port
            - username
            - password
            - containerID: "'test_sshd'"
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_DELETE_CONTAINER

  results:
    - SUCCESS
    - FAIL_VALIDATE_SSH
    - FAIL_PULL_IMAGE
    - FAIL_START_DOCKER
    - FAIL_STOP_CONTAINER
    - FAIL_DELETE_CONTAINER
    - FAILURE
