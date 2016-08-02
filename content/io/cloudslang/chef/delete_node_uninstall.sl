#   (c) Copyright 2015 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Remove node and client from Chef, delete /etc/chef folder on node.
#! @input node_name: name of node in Chef to be deleted
#! @input knife_host: IP of server with configured knife accessable via SSH, can be main Chef server
#! @input knife_username: SSH username to access server with knife
#! @input knife_password: optional - password to access server with knife
#! @input knife_privkey: optional - path to local SSH keyfile for accessing server with knife
#! @input node_host: hostname or IP of Chef node
#! @input node_username: SSH username for the Chef node
#! @input node_password: optional - password to access node
#! @input node_privkey: optional - path on <knife_host> to keyfile for accessing node
#! @input knife_config: optional - location of knife.rb config file
#! @output knife_result: filtered output of knife command
#! @output raw_result: full STDOUT
#! @output standard_err: any STDERR
#! @result SUCCESS: node deleted OK
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.chef

imports:
  ssh: io.cloudslang.base.ssh
  chef: io.cloudslang.chef

flow:
  name: delete_node_uninstall
  inputs:
    - node_name
    - knife_host
    - knife_username
    - knife_password:
        required: false
        sensitive: true
    - knife_privkey:
        required: false
    - node_host
    - node_username
    - node_password:
        required: false
        sensitive: true
    - node_privkey:
        required: false
    - knife_config:
        required: false

  workflow:
    - remove_node_from_chef:
        do:
          chef.delete_node:
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
