#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Bootstrap a server so it can be managed by Chef as a new node.
#! @input node_name: new node name in Chef
#! @input node_host: hostname or IP of server to boostrap
#! @input node_username: SSH username to boostrap the new node
#! @input node_password: optional - password to access node
#! @input node_privkey: optional - path on <knife_host> to keyfile for accessing node
#! @input knife_host: IP of server with configured knife accessable via SSH, can be main Chef server
#! @input knife_username: SSH username to access server with knife
#! @input knife_privkey: optional - path to local SSH keyfile for accessing server with knife
#! @input knife_password: optional - password to access server with knife
#! @input knife_timeout: optional - timeout in milliseconds - Default: '600000'
#! @input knife_config: optional - location of knife.rb config file
#! @output raw_result: full STDOUT
#! @output knife_result: filtered output of knife command
#! @output standard_err: any STDERR
#! @output new_node_name: new node name in Chef
#! @result SUCCESS: bootstrap process completed without errors
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.chef

imports:
  strings: io.cloudslang.base.strings
  chef: io.cloudslang.chef

flow:
  name: bootstrap_node
  inputs:
    - node_name
    - node_host
    - node_username
    - node_password:
        required: false
        sensitive: true
    - node_privkey:
        required: false
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password:
        required: false
        sensitive: true
    - knife_timeout:
        default: '600000'
        required: false
    - knife_config:
        required: false
    - node_password_expr:
        default: ${(" -P '" + node_password + "'") if node_password else ''}
        private: true
        sensitive: true
    - node_privkey_expr:
        default: ${(' -i ' + node_privkey) if node_privkey else ''}
        private: true
  workflow:
    - run_bootstrap:
        do:
          chef.knife_command:
            - knife_cmd: >
                ${'bootstrap ' + node_host + node_privkey_expr + ' -x ' + node_username +
                node_password_expr + ' --sudo --node-name \'' + node_name + '\''}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_timeout
            - knife_config
        publish:
          - raw_result
          - standard_err

    - check_knife_result:
        do:
          strings.string_occurrence_counter:
             - string_in_which_to_search: ${standard_err + '\n' + raw_result}
             - string_to_find: 'error'
        publish:
          - errs_c: ${return_result}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: filter_bootstrap_result

    - filter_bootstrap_result:
        do:
          strings.filter_lines:
            - text: ${raw_result}
            - filter: ${node_host}
        publish:
          - filter_result

  outputs:
    - raw_result: ${raw_result}
    - knife_result: ${standard_err  + ' ' + (filter_result if 'filter_result' in locals() else raw_result)}
    - standard_err: ${standard_err}
    - new_node_name: ${node_name}
