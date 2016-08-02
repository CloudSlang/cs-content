#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Extracts runc container dump files.
#! @input docker_host: The Docker host which the tar files were copied to.
#! @input port: The ssh port used by the Docker host.
#! @input username: A user with sufficient privileges to extract the files.
#! @input password: The user's password.
#! @input pre_dump: Indicates if a predump image should be extracted. - Example: "false"
#! @input runc_container: the name of the container which the dump files belong to . - Example: "redis"
#! @input root_path: the full path to the folder which contains the containers folders . - Example: "/usr/local/migrate/"
#! @input predump_image_location: the full path to the folder which will contain the container's pre_dump image.
#! @input dump_image_location: the full path to the folder which will contain the container's dump image.
#! @result SUCCESS:
#! @result GET_CONTEXT_FAILURE:
#! @result EXTRACT_PRE_DUMP_FAILURE:
#! @result EXTRACT_DUMP_FAILURE:
#!!#
#
####################################################
namespace: io.cloudslang.docker.runc.examples

imports:
  ssh: io.cloudslang.base.ssh
  comparisons: io.cloudslang.base.comparisons
  print: io.cloudslang.base.print

flow:
  name: extract_images
  inputs:
    - docker_host
    - port: "22"
    - username
    - password
    - runc_container
    - root_path: "/usr/local/migrate"
    - pre_dump: "false"
    - predump_image_location: ${root_path + "/" + runc_container + "/predump"}
    - dump_image_location: ${root_path + "/" + runc_container + "/dump"}
  workflow:
  - check arguments:
      do:
        comparisons.equals:
          - first: ${pre_dump}
          - second: "true"
      navigate:
          - EQUALS: extract_pre_dump
          - NOT_EQUALS: extract_dump
  - extract_pre_dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: ${"cd " + root_path + "/" + runc_container + "; tar -xf predump.tar predump"}
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - return_result
      navigate:
          - SUCCESS: extract_dump
          - FAIL_VALIDATE_SSH: EXTRACT_PRE_DUMP_FAILURE
          - FAILURE: EXTRACT_PRE_DUMP_FAILURE
  - extract_dump:
      do:
        ssh.ssh_flow:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - command: ${"cd " + root_path + "/" + runc_container + "; tar -xf dump.tar dump"}
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
          - FAIL_VALIDATE_SSH: EXTRACT_DUMP_FAILURE
          - FAILURE: print_step
  - print_step:
      do:
        print.print_text:
          - text: ${"cd " + root_path + "/" + runc_container + "; tar -xf dump.tar dump"}
      navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - EXTRACT_DUMP_FAILURE
    - EXTRACT_PRE_DUMP_FAILURE
