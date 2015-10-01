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
  utils: io.cloudslang.base.utils

flow:
  name: test_remote_secure_copy_local_to_remote
  inputs:
    - host
    - username
    - port
    - scp_host_port
    - scp_file
    - scp_username
    - key_name
    - text_to_check
    - docker_scp_image:
        default: "'gituser173/docker-scp-server'"
        overridable: false
    - authorized_keys_path:
        default: "'~/.ssh/authorized_keys'"
        overridable: false
    - container_path:
        default: "'/home/data/'"
        overridable: false

  workflow:

    - pull_scp_image:
        do:
          base_cmd.run_command:
            - command: "'docker pull ' + docker_scp_image"
        navigate:
          SUCCESS: generate_key
          FAILURE: SCP_IMAGE_NOT_PULLED

    - generate_key:
        do:
          base_cmd.run_command:
            - command: "'echo -e \"y\" | ssh-keygen -t rsa -N \"\" -f ' + key_name + ' && rm -f ~/.ssh/known_hosts'"
        navigate:
          SUCCESS: add_key_to_authorized
          FAILURE: KEY_GENERATION_FAIL

    - add_key_to_authorized:
        do:
          base_cmd.run_command:
            - command: "'cat ' + key_name + '.pub >> ' + authorized_keys_path"
        navigate:
          SUCCESS: create_scp_host
          FAILURE: KEY_ADDITION_FAIL

    - create_scp_host:
        do:
          base_cmd.run_command:
            - command: "'docker run -d -e AUTHORIZED_KEYS=$(base64 -w0 ' + authorized_keys_path + ') -p ' + scp_host_port + ':22 --name test1 -v /data:' + container_path + ' ' + docker_scp_image"
        navigate:
          SUCCESS: create_file_to_be_copied
          FAILURE: SCP_HOST_NOT_STARTED

    - create_file_to_be_copied:
        do:
          base_cmd.run_command:
            - command: "'echo ' + text_to_check + ' >> ' + scp_file"
        navigate:
          SUCCESS: sleep
          FAILURE: FILE_CREATION_FAIL

    - sleep:
        do:
          utils.sleep:
            - seconds: 30
        navigate:
          SUCCESS: test_remote_secure_copy
          FAILURE: SLEEP_FAIL

    - test_remote_secure_copy:
        do:
          base_rft.remote_secure_copy:
            - sourcePath: "scp_file"
            - destinationHost: host
            - destinationPath: "container_path + scp_file"
            - destinationPort: scp_host_port
            - destinationUsername: scp_username
            - destinationPrivateKeyFile: key_name
        navigate:
          SUCCESS: get_file_from_scp_host
          FAILURE: RFT_FAILURE

    - get_file_from_scp_host:
        do:
          base_cmd.run_command:
            - command: "'scp -P ' + scp_host_port + ' -o \"StrictHostKeyChecking no\" -i ' + key_name + ' ' + scp_file + ' ' + scp_username + '@' + host + ':' + container_path + scp_file"
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
            - second_string: read_text.strip()
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FILE_CHECK_FAIL

  results:
    - SUCCESS
    - ADD_ALGORITHMS_FAIL
    - RFT_FAILURE
    - SCP_IMAGE_NOT_PULLED
    - KEY_GENERATION_FAIL
    - KEY_ADDITION_FAIL
    - SCP_HOST_NOT_STARTED
    - SLEEP_FAIL
    - FILE_CREATION_FAIL
    - FILE_READ_FAIL
    - FILE_CHECK_FAIL
    - FILE_REACHING_SCP_HOST_FAIL