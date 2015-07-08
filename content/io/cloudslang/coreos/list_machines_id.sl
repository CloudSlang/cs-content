#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#####################################################
# Retrieves the ID list of machines deployed in a CoreOS cluster.
#
# Inputs:
#   - host - CoreOS machine host; can be any machine from the cluster
#   - port - optional - SSH port
#   - username - CoreOS machine username
#   - password - optional - CoreOS machine password; can be empty since CoreOS machines use private key file authentication
#   - private_key_file - optional - path to the private key file
#   - arguments - optional - arguments to pass to the command
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if false SSH session will be cached for future calls of this operation during life of the flow, if true SSH session used by this operation will be closed - Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - machines_id_list  - space delimited list of IDs of machines deployed in the CoreOS cluster
# Results:
#   - SUCCESS - action was executed successfully and no error message is found in the STDERR
#   - FAILURE - otherwise
#####################################################

namespace: io.cloudslang.coreos

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings

flow:
  name: list_machines_id

  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - arguments:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false
    - command:
        default: >
          "fleetctl list-machines | awk '{print $1}'"
        overridable: false

  workflow:
    - get_machine_public_ip:
        do:
          ssh.ssh_flow:
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - privateKeyFile:
                default: private_key_file
                required: false
            - command
            - arguments:
                required: false
            - characterSet:
                default: character_set
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - closeSession:
                default: close_session
                required: false
            - agentForwarding:
                default: agent_forwarding
                required: false
        publish:
          - machines_id_list: >
              returnResult.replace("\n"," ").replace("MACHINE ","",1).replace("...", "")[:-1]
              if (return_code == '0' and (not 'ERROR' in standard_err)) else ''
          - standard_err

    - check_error_in_stderr:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: standard_err
            - string_to_find: "'ERROR'"
        navigate:
          SUCCESS: FAILURE
          FAILURE: SUCCESS
  outputs:
    - machines_id_list
