#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Remove node and client from Chef, delete /etc/chef folder on node.
#
# Inputs:
#   - node_name - name of node in Chef to be deleted
#   - knife_host - server with configured knife accessable via SSH, can be main Chef server
#   - knife_username - SSH username to access server with knife
#   - knife_password - optional - password to access server with knife
#   - knife_privkey - optional - SSH keyfile to access server with knife (local file that resides where flow is executing)
#   - knife_config - optional - location of knife.rb config file
# Outputs:
#   - knife_result - filtered output of knife command
#   - raw_result - full STDOUT
#   - standard_err - any STDERR
# Results:
#   - SUCCESS - node deleted OK
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.chef

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: delete_node
  inputs:
    - node_name
    - knife_host
    - knife_username
    - knife_password:
        required: false
    - knife_privkey:
        required: false
    - knife_config:
        required: false

  workflow:
    - remove_client:
        do:
          knife_command:
            - knife_cmd: ${'client delete ' + node_name + ' -y'}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

    - remove_node:
        do:
          knife_command:
            - knife_cmd: ${'node delete ' + node_name + ' -y'}
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

  outputs:
    - knife_result
    - raw_result
    - standard_err
