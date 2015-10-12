#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# CHEF TEST FLOW
# This flow tests Chef content
#  - Chef bootstrap existing Linux host
#  - Assign Chef cookbook(s)
#  - Run Chef client
####################################################

namespace: io.cloudslang.chef

imports:
  chef: io.cloudslang.chef
  ssh: io.cloudslang.base.remote_command_execution.ssh
  print: io.cloudslang.base.print

flow:
  name: test_chef_bootstrap_run
  inputs:
    # General inputs
    - node_host
    - node_name
    # Chef details
    - cookbooks
    - knife_host
    - knife_username
    - knife_password: 
        default: "''"
        required: false
    - knife_privkey:
        default: "''"
        required: false    
    - node_username
    - node_privkey:
        default: "''"
        required: false  
    - node_privkey_local:
        default: "''"
        required: false 
    - node_password: 
        default: "''"
        required: false

  workflow:
    - chef_bootstrap:
        do:
          chef.bootstrap_node:
            - node_host
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey           
            - node_username
            - node_password            
            - node_privkey           
        publish:
          - return_result: knife_result
          - standard_err
          - node_name

    - chef_assign_cookbook:
        do:
          chef.assign_cookbooks:
            - cookbooks
            - node_name
            - knife_host
            - knife_username
            - knife_password
            - knife_privkey           
            - node_username
            - node_password            
            - node_privkey
        publish:
          - return_result: knife_result
          - standard_err

    - chef_run_client:
        do:
          ssh.ssh_command:
            - host: node_host
            - username: node_username
            - password: node_password                
            - privateKeyFile: node_privkey_local           
            - command: "'sudo chef-client'"
            - timeout: "'600000'"
        publish:
          - return_result: returnResult
          - standard_err

    - on_failure:
      - ERROR:
          do:
            print.print_text:
              - text: "'! Error in Chef test flow ' +standard_err"