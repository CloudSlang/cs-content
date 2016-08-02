#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Creates a checkpoint for a running runc container.
#! @input pre_dump: perform a pre-dump checkpoint (true/false). - Example: "false"
#! @input docker_host: the address of the Docker host to checkpoint . - Example: "192.168.0.1"
#! @input port: The ssh port used by the Docker host.
#! @input username: A user with sufficient privileges to checkpoint the container.
#! @input password: The user's password.
#! @input runc_container: the name of the container to checkpoint . - Example: "redis"
#! @input root_path: the full path to the folder which contains the containers folders . - Example: "/usr/local/migrate/"
#! @input predump_image_location: the full path to the folder which will contain the container's pre_dump image.
#! @input dump_image_location: the full path  to the folder which will contain the container's dump image.
#! @result SUCCESS:
#! @result PRE_DUMP_FAILURE:
#! @result DUMP_FAILURE:
#!!#
#
####################################################
namespace: io.cloudslang.docker.runc

imports:
  ssh: io.cloudslang.base.ssh
  comparisons: io.cloudslang.base.comparisons
flow:
  name: checkpoint_container
  inputs:
    - docker_host
    - port: "22"
    - username
    - password
    - runc_container: "redis"
    - root_path: "/usr/local/migrate/"
    - pre_dump: "false"
    - predump_image_location: ${root_path + runc_container + "/predump"}
    - dump_image_location: ${root_path + runc_container + "/dump"}
  workflow:
  - check_params:
      do:
        comparisons.equals:
          - first: ${pre_dump}
          - second: "true"
      navigate:
          - EQUALS: pre_dump
          - NOT_EQUALS: dump
  - pre_dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: ${"docker-runc checkpoint  --pre-dump --image-path " + predump_image_location}
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - return_result
      navigate:
          - SUCCESS: SUCCESS
          - FAIL_VALIDATE_SSH: PRE_DUMP_FAILURE
          - FAILURE: PRE_DUMP_FAILURE
  - dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: ${"docker-runc checkpoint --tcp-established --image-path " + dump_image_location + "  --ext-unix-sk --file-locks " +  runc_container}
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - return_result
      navigate:
          - SUCCESS: SUCCESS
          - FAIL_VALIDATE_SSH: DUMP_FAILURE
          - FAILURE: DUMP_FAILURE
  results:
    - SUCCESS
    - PRE_DUMP_FAILURE
    - DUMP_FAILURE
