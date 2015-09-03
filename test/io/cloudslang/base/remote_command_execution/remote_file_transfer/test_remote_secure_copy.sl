#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.base.remote_command_execution.remote_file_transfer

imports:
  base_cmd: io.cloudslang.base.cmd
  base_rft: io.cloudslang.base.remote_command_execution.remote_file_transfer
  base_files: io.cloudslang.base.files
  base_strings: io.cloudslang.base.strings
  maintenance: io.cloudslang.docker.maintenance
  containers: io.cloudslang.docker.containers

flow:
  name: test_remote_secure_copy
  inputs:
    - host
    - username
    - password
    - port

  workflow:
    - pre_clear_machine:
        do:
          containers.clear_containers:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: PREREQUEST_MACHINE_IS_NOT_CLEAN

    - pull_scp_image:
        do:
          base_cmd.run_command:
            - command: "'docker pull schoolscout/scp-server'"
        navigate:
          SUCCESS: generate_key
          FAILURE: SCP_IMAGE_NOT_PULLED

    - generate_key:
        do:
          base_cmd.run_command:
            - command: "'echo -e \"y\" | ssh-keygen -t rsa -N \"\" -f key'"
        navigate:
          SUCCESS: add_key_to_authorized
          FAILURE: KEY_GENERATION_FAIL

    - add_key_to_authorized:
        do:
          base_cmd.run_command:
            - command: "'echo \"$(cat key.pub)\" >> ~/.ssh/authorized_keys'"
        navigate:
          SUCCESS: encrypt_and_store_authorized_keys
          FAILURE: KEY_ADDITION_FAIL

    - encrypt_and_store_authorized_keys:
        do:
          base_cmd.run_command:
            - command: "'AUTHORIZED_KEYS=$(base64 -w0 ~/.ssh/authorized_keys)'"
        navigate:
          SUCCESS: create_needed_folders
          FAILURE: KEY_STORE_FAIL

    - create_needed_folders:
        do:
          base_cmd.run_command:
            - command: "'mkdir data1 data2'"
        navigate:
          SUCCESS: create_first_host
          FAILURE: FOLDER_CREATION_FAIL

    - create_first_host:
        do:
          base_cmd.run_command:
            - command: "'docker run -d -e AUTHORIZED_KEYS=$AUTHORIZED_KEYS -p 22022:22 -v /data1:/home/data schoolscout/scp-server'"
        navigate:
          SUCCESS: create_second_host
          FAILURE: FIRST_HOST_NOT_STARTED

    - create_second_host:
        do:
          base_cmd.run_command:
            - command: "'docker run -d -e AUTHORIZED_KEYS=$AUTHORIZED_KEYS -p 22023:22 -v /data2:/home/data schoolscout/scp-server'"
        navigate:
          SUCCESS: create_file_and_copy_it_to_src_host
          FAILURE: SECOND_HOST_NOT_STARTED

    - create_file_and_copy_it_to_src_host:
        do:
          base_cmd.run_command:
            - command: "'echo \"hello world\" >> file.txt && scp -P 22022 -o \"StrictHostKeyChecking no\" -i key data@localhost:/home/data/file.txt file.txt'"
        navigate:
          SUCCESS: test_remote_secure_copy
          FAILURE: FILE_REACHING_SRC_HOST_FAIL

    - test_remote_secure_copy:
        do:
          base_rft.remote_secure_copy:
            - sourceHost: "'localhost'"
            - sourcePath: "'/home/data/file.txt'"
            - sourcePort: "'22022'"
            - sourceUsername: "'data'"
            - sourcePrivateKeyFile: "'key'"
            - destinationHost: "'localhost'"
            - destinationPath: "'/home/data/file.txt'"
            - destinationPort: "'22023'"
            - destinationUsername: "'data'"
            - destinationPrivateKeyFile: "'key'"
        navigate:
          SUCCESS: get_file_from_dest_host
          FAILURE: FAILURE

    - get_file_from_dest_host:
        do:
          base_cmd.run_command:
            - command: "'scp -P 22023 -o \"StrictHostKeyChecking no\" -i key file.txt data@localhost:/home/data/file.txt'"
        navigate:
          SUCCESS: read_file
          FAILURE: FILE_REACHING_DEST_HOST_FAIL

    - read_file:
        do:
          base_files.read_from_file:
            - file_path: "'file.txt'"
        publish:
          - read_text
        navigate:
          SUCCESS: check_text
          FAILURE: FILE_READ_FAIL

    - check_text:
        do:
          base_strings.string_equals:
            - first_string: "'hello world'"
            - second_string: read_text
        navigate:
          SUCCESS: post_clear_machine
          FAILURE: FILE_CHECK_FAIL

    - post_clear_machine:
        do:
          containers.clear_containers:
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - port:
                required: false
        navigate:
          SUCCESS: SUCCESS
          FAILURE: POSTREQUEST_MACHINE_IS_NOT_CLEAN

  results:
    - SUCCESS
    - FAILURE
    - SCP_IMAGE_NOT_PULLED
    - KEY_GENERATION_FAIL
    - KEY_ADDITION_FAIL
    - FOLDER_CREATION_FAIL
    - FIRST_HOST_NOT_STARTED
    - SECOND_HOST_NOT_STARTED
    - FILE_REACHING_SRC_HOST_FAIL
    - FILE_REACHING_DEST_HOST_FAIL
    - FILE_READ_FAIL
    - FILE_CHECK_FAIL
    - POSTREQUEST_MACHINE_IS_NOT_CLEAN
    - PREREQUEST_MACHINE_IS_NOT_CLEAN
    - KEY_STORE_FAIL
