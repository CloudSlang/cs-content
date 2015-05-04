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

flow:
  name: test_restart_service
  inputs:
    - host
    - port
    - username
    - password
    - service_name
    - imageName: >
           rastasheep/ubuntu-sshd

  workflow:
    - validate_ssh:
        do:
          linux.validate_linux_machine_ssh_access:
            - host
            - port
            - username
            - password
        navigate:
          SUCCESS: pull_test_image
          FAILURE: FAIL_VALIDATE_SSH

    - pull_test_image:
        do:
          images.pull_image:
            - host
            - port
            - username
            - password
            - imageName
        navigate:
          SUCCESS: start_docker
          FAILURE: FAIL_PULL_IMAGE

    - start_docker:
        do:
          ssh.ssh_command:
            - host
            - port
            - username
            - password
            - command: "'docker run -d -P -p 49160:22 --name test_sshd rastasheep/ubuntu-sshd'"
        navigate:
          SUCCESS: restart_service
          FAILURE: FAIL_START_DOCKER

    - restart_service:
        do:
          linux.restart_service:
            - host: localhost
            - port: "49160"
            - username: root
            - password: root
            - service_name: sudo
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
