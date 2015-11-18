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
#   - knife_password - optional - if using password auth
#   - knife_privkey - optional - SSH keyfile, if using keyfile auth  (local file that resides where flow is executing)
#   - node_host - hostname or IP of Chef node
#   - node_username - SSH username for the Chef node
#   - node_password - optional - if using password auth to access node
#   - node_privkey - optional - if using keyfile auth to access node (local file that resides where flow is executing)
#   - chef_repo - optional - relative or absolute path to the chef repository on Chef Workstation
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
  name: delete_node_uninstall
  inputs:
    - node_name
    - knife_host
    - knife_username
    - knife_password:
        required: false
    - knife_privkey:
        required: false
    - node_host
    - node_username
    - node_password:
        required: false
    - node_privkey:
        required: false
    - knife_config:
        required: false

  workflow:
    - remove_node_from_chef:
        do:
          delete_node:
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey
            - knife_config
        publish:
          - raw_result
          - standard_err
          - knife_result

    - uninstall_chef_client:
        do:
          ssh.ssh_command:
            - command: ${'sudo rm -rf /etc/chef;sudo dpkg -P chef'}
            - host: ${node_host}
            - username: ${node_username}
            - password: ${node_password}
            - privateKeyFile: ${node_privkey}
        publish:
          - raw_result: ${returnResult}
          - standard_err
  outputs:
    - knife_result
    - raw_result
    - standard_err