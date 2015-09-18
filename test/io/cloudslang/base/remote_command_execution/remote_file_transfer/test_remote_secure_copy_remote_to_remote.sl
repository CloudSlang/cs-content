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
  base_print: io.cloudslang.base.print

flow:
  name: test_remote_secure_copy_remote_to_remote
  inputs:
    - host
    - username
    - port
    - first_scp_host_port
    - second_scp_host_port
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
          SUCCESS: cat1
          FAILURE: KEY_GENERATION_FAIL
    - cat1:
        do:
          base_cmd.run_command:
            - command: "'cat ' + key_name + '.pub'"
        navigate:
          SUCCESS: add_key_to_authorized
          FAILURE: FAILURE

    - add_key_to_authorized:
        do:
          base_cmd.run_command:
            - command: "'cat ' + key_name + '.pub >> ' + authorized_keys_path"
        navigate:
          SUCCESS: cat2
          FAILURE: KEY_ADDITION_FAIL

    - cat2:
        do:
          base_cmd.run_command:
            - command: "'cat ' + authorized_keys_path"
        navigate:
          SUCCESS: create_first_host
          FAILURE: FAILURE

    - create_first_host:
        do:
          base_cmd.run_command:
            - command: "'docker run -d -e AUTHORIZED_KEYS=$(base64 -w0 ' + authorized_keys_path + ') -p ' + first_scp_host_port + ':22 -v /data1:' + container_path + ' ' + docker_scp_image"
        navigate:
          SUCCESS: create_second_host
          FAILURE: FIRST_HOST_NOT_STARTED

    - create_second_host:
        do:
          base_cmd.run_command:
            - command: "'docker run -d -e AUTHORIZED_KEYS=$(base64 -w0 ' + authorized_keys_path + ') -p ' + second_scp_host_port + ':22 -v /data2:' + container_path + ' ' + docker_scp_image"
        navigate:
          SUCCESS: create_file_and_copy_it_to_src_host
          FAILURE: SECOND_HOST_NOT_STARTED

    - create_file_and_copy_it_to_src_host:
        do:
          base_cmd.run_command:
            - command: "'echo ' + text_to_check + ' >> ' + scp_file + ' && scp -vvv -P ' + first_scp_host_port + ' -o \"StrictHostKeyChecking no\" -i ' + key_name  + ' ' + scp_file + ' ' + scp_username + '@' + host + ':' + container_path + scp_file"
        navigate:
          SUCCESS: test_remote_secure_copy
          FAILURE: FILE_REACHING_SRC_HOST_FAIL

    - test_remote_secure_copy:
        do:
          base_rft.remote_secure_copy:
            - sourceHost: host
            - sourcePath: "container_path + scp_file"
            - sourcePort: first_scp_host_port
            - sourceUsername: scp_username
            - sourcePrivateKeyFile: key_name
            - destinationHost: host
            - destinationPath: "container_path + scp_file"
            - destinationPort: second_scp_host_port
            - destinationUsername: scp_username
            - destinationPrivateKeyFile: key_name
        navigate:
          SUCCESS: get_file_from_dest_host
          FAILURE: RFT_FAILURE
        publish:
          - return_result

    - get_file_from_dest_host:
        do:
          base_cmd.run_command:
            - command: "'scp -P ' + second_scp_host_port + ' -o \"StrictHostKeyChecking no\" -i ' + key_name + ' '  + scp_username + '@' + host + ':' + container_path + scp_file + ' ' + scp_file"
        navigate:
          SUCCESS: read_file
          FAILURE: FILE_REACHING_DEST_HOST_FAIL

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
    - print:
        do:
          base_print.print_text:
            - text: return_result
        navigate:
          SUCCESS: RFT_FAILURE

  results:
    - SUCCESS
    - RFT_FAILURE
    - SCP_IMAGE_NOT_PULLED
    - KEY_GENERATION_FAIL
    - KEY_ADDITION_FAIL
    - FIRST_HOST_NOT_STARTED
    - SECOND_HOST_NOT_STARTED
    - FILE_REACHING_SRC_HOST_FAIL
    - FILE_REACHING_DEST_HOST_FAIL
    - FILE_READ_FAIL
    - FILE_CHECK_FAIL
    - FAILURE