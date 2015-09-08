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
  name: test_remote_secure_copy_local_to_remote
  inputs:
    - host
    - username
    - password
    - port
    - scp_host_port
    - scp_path
    - scp_file
    - scp_username
    - key_name
    - text_to_check
    - docker_scp_image:
        default: "'schoolscout/scp-server'"
        overridable: false
    - authorized_keys_path:
        default: "'~/.ssh/authorized_keys'"
        overridable: false

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
            - command: "'docker pull' + docker_scp_image"
        navigate:
          SUCCESS: generate_key
          FAILURE: SCP_IMAGE_NOT_PULLED

    - generate_key:
        do:
          base_cmd.run_command:
            - command: "'echo -e \"y\" | ssh-keygen -t rsa -N \"\" -f ' + key_name"
        navigate:
          SUCCESS: add_key_to_authorized
          FAILURE: KEY_GENERATION_FAIL

    - add_key_to_authorized:
        do:
          base_cmd.run_command:
            - command: "'echo \"$(cat ' + key_name + '.pub)\" >> ' + authorized_keys_path"
        navigate:
          SUCCESS: encrypt_and_store_authorized_keys
          FAILURE: KEY_ADDITION_FAIL

    - encrypt_and_store_authorized_keys:
        do:
          base_cmd.run_command:
            - command: "'AUTHORIZED_KEYS=$(base64 -w0 ' + authorized_keys_path"
        navigate:
          SUCCESS: create_needed_folder
          FAILURE: KEY_STORE_FAIL

    - create_needed_folder:
        do:
          base_cmd.run_command:
            - command: "'mkdir data'"
        navigate:
          SUCCESS: create_scp_host
          FAILURE: FOLDER_CREATION_FAIL

    - create_scp_host:
        do:
          base_cmd.run_command:
            - command: "'docker run -d -e AUTHORIZED_KEYS=$AUTHORIZED_KEYS -p ' + scp_host_port + ':22 -v /data:' + scp_path + ' + docker_scp_image"
        navigate:
          SUCCESS: create_file_to_be_copied
          FAILURE: SCP_HOST_NOT_STARTED

    - create_file_to_be_copied
        do:
          base_cmd.run_command:
            - command: "'echo text_to_check >> ' + scp_file"
        navigate:
          SUCCESS: test_remote_secure_copy
          FAILURE: FILE_CREATION_FAIL

    - test_remote_secure_copy:
        do:
          base_rft.remote_secure_copy:
            - sourcePath: "scp_file"
            - destinationHost: host
            - destinationPath: "scp_path + scp_file"
            - destinationPort: scp_host_port
            - destinationUsername: scp_username
            - destinationPrivateKeyFile: key_name
        navigate:
          SUCCESS: get_file_from_scp_host
          FAILURE: FAILURE

    - get_file_from_scp_host:
        do:
          base_cmd.run_command:
            - command: "'scp -P ' + scp_host_port + ' -o \"StrictHostKeyChecking no\" -i ' + key_name + ' ' + scp_file + ' ' + scp_username + '@' + host + ':' + scp_path + scp_file"
        navigate:
          SUCCESS: read_file
          FAILURE: FILE_REACHING_SCP_HOST_FAIL

    - read_file:
        do:
          base_files.read_from_file:
            - file_path: scp_file
        publish:
          - read_text
        navigate:
          SUCCESS: check_text
          FAILURE: FILE_READ_FAIL

    - check_text:
        do:
          base_strings.string_equals:
            - first_string: text_to_check
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
    - SCP_HOST_NOT_STARTED
    - FILE_CREATION_FAIL
    - FILE_READ_FAIL
    - FILE_CHECK_FAIL
    - FILE_REACHING_SCP_HOST_FAIL
    - POSTREQUEST_MACHINE_IS_NOT_CLEAN
    - PREREQUEST_MACHINE_IS_NOT_CLEAN
    - KEY_STORE_FAIL