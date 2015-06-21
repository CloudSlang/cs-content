#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Retrieves a list of all the Docker images.
#
# Inputs:
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - privateKeyFile - optional - absolute path to private key file
#   - arguments - optional - arguments to pass to the command
#   - characterSet - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false - Default: false
#   - timeout - time in milliseconds to wait for command to complete
#   - closeSession - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false - Default: false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - image_list - list containing REPOSITORY and TAG for all the Docker images
# Results:
#   - SUCCESS - SSH command succeeded
#   - FAILURE - SSH command failed
####################################################
namespace: io.cloudslang.docker.images

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: get_all_images
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - privateKeyFile:
        required: false
    - command:
        default: >
            "docker images | awk '{print $1 \":\" $2}'"
        overridable: false
    - arguments:
        required: false
    - characterSet:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - closeSession:
        required: false
    - agentForwarding:
        required: false
  workflow:
    - get_images:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                required: false
            - command
            - arguments:
                required: false
            - characterSet:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                required: false
            - agentForwarding:
                required: false
        publish:
            - returnResult
            - return_code
            - standard_err

    - verify_no_error_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_err
            - string_to_find: "'Error'"
        navigate:
          SUCCESS: FAILURE
          FAILURE: verify_no_command_not_found_in_stderr

    - verify_no_command_not_found_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_err
            - string_to_find: "'command not found'"
        navigate:
          SUCCESS: FAILURE
          FAILURE: verify_no_deamon_in_stderr

    - verify_no_deamon_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_err
            - string_to_find: "'deamon'"
        navigate:
          SUCCESS: FAILURE
          FAILURE: SUCCESS

  outputs:
    - image_list: returnResult.replace("\n"," ").replace("<none>:<none> ","").replace("REPOSITORY:TAG ","")
  results:
    - SUCCESS
    - FAILURE