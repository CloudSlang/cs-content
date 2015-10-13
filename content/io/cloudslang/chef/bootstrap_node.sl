#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Bootstrap a server so it can be managed by Chef as a new node
#
# Inputs:
#   - node_name - new node name in Chef
#   - node_host - hostname or IP of server to boostrap
#   - node_username - SSH username to boostrap the new node
#   - node_password - optional - if using password auth to access node
#   - node_privkey - optional - if using keyfile auth to access node (*REMOTE FILE* on knife server)
#   - knife_host - server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - if using password auth
#   - knife_privkey - optional - SSH keyfile, if using keyfile auth  (local file that resides where flow is executing)
#   - knife_timeout - optional - timeout in millsecs, default is 600 seconds
# Outputs:
#   - raw_result - full STDOUT
#   - knife_result - filtered output of knife command
#   - standard_err - any STDERR
# Results:
#   - SUCCESS - bootstrap process completed without errors
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.chef
imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh
  strings: io.cloudslang.base.strings
flow:
  name: bootstrap_node
  inputs:
    - node_name
    - node_host     
    - node_username
    - node_password:
        required: false
    - node_privkey:
        required: false      
    - knife_host
    - knife_username
    - knife_privkey:
        required: false
    - knife_password: 
        required: false
    - knife_timeout:
        default: "'600000'"
        required: false
  workflow:
    - run_bootstrap:
        do:
          ssh.ssh_command:
            - host: knife_host
            - username: knife_username
            - password: knife_password
            - privateKeyFile: knife_privkey                          
            - command: >
                'knife bootstrap ' + node_host + ' -i ' + node_privkey + ' -x ' + node_username +
                ' -P \'' + node_password + '\' --sudo --node-name \'' + node_name + '\''
            - timeout: knife_timeout
        publish:
          - returnResult
          - standard_err

    - check_knife_result:
        do:
          strings.string_occurrence_counter:
             - string_in_which_to_search: standard_err + '\n' + returnResult
             - string_to_find: "'error'"
        publish:
          - errs_c: return_result
        navigate:
          SUCCESS: FAILURE
          FAILURE: filter_bootstrap_result

    - filter_bootstrap_result:
        do:
          strings.filter_lines:
            - text: returnResult
            - filter: node_host
        publish:
          - filter_result

  outputs:
    - raw_result: returnResult
    - knife_result: "standard_err  + ' ' + (filter_result if 'filter_result' in locals() else returnResult)"
    - standard_err: standard_err
    - node_name

  results:
    - SUCCESS
    - FAILURE
